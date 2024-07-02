{
  lib,
  stdenv,
  nodejs_20,
  buildNpmPackage,
  fetchFromGitHub,
  fetchzip,
  writeShellScriptBin,
  nss,
}:

let
  nodejs = nodejs_20;
  buildNpmPackage' = buildNpmPackage.override { inherit nodejs; };

  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "httptoolkit";
    repo = "httptoolkit-server";
    rev = "v${version}";
    hash = "sha256-/HaLnr7Vsza7tauMMzJ+h8yxY5XVFN9Uyr9F3f+VLjk=";
  };

  overridesNodeModules = buildNpmPackage' {
    pname = "httptoolkit-server-overridesNodeModules";
    inherit version src;
    sourceRoot = "${src.name}/overrides/js";

    npmDepsHash = "sha256-GRN6ua3FY1AE61bB7PM2wgbKPZI/zJeXa5HOOh/2N2Y=";

    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/node_modules
    '';
  };

  nodeDatachannelPrebuilt =
    let
      version = "0.4.3";
      platformTable = {
        "x86_64-linux" = {
          id = "linux-x64";
          hash = "sha256-RVBuAI9jtNb4IfzWrz1jxsOoPn5mQdWAbwKOEgcoWtE=";
        };
        "aarch64-linux" = {
          id = "linux-arm64";
          hash = "sha256-PpYbfyOSgseqpuifQIbCr5ce58HSob8FcM7R7hxgT6Y=";
        };
        "x86_64-darwin" = {
          id = "darwin-x64";
          hash = "sha256-c5w9ZL+P14H4ZL5PHXssIvwph+v/2VU/+8fu2EUXDD4=";
        };
        "aarch64-darwin" = {
          id = "darwin-arm64";
          hash = "sha256-6F0rrqFLVRDB9eptosjLh8p9p2olqpwbexJpFLlNLXk=";
        };
      };
      inherit (stdenv.hostPlatform) system;
      platformInfo = platformTable.${system} or (throw "Unsupported system: ${system}");
    in
    fetchzip {
      url = "https://github.com/murat-dogan/node-datachannel/releases/download/v${version}/node-datachannel-v${version}-node-v108-${platformInfo.id}.tar.gz";
      inherit (platformInfo) hash;
    };

in
buildNpmPackage' {
  pname = "httptoolkit-server";
  inherit version src;

  patches = [ ./only-build-for-one-platform.patch ];

  npmDepsHash = "sha256-ysj3Q5oWqPRthJck/lMYxdzygMkFw5lWaVHtCoZNN3c=";

  npmFlags = [ "--ignore-scripts" ];

  makeCacheWritable = true;

  nativeBuildInputs = [
    # the build system uses the `git` executable to get the current revision
    # we use a fake git to provide it with a fake revision
    (writeShellScriptBin "git" "echo '???'")
  ];

  postConfigure = ''
    # make sure `oclif-dev' doesn't fetch `node` binary to bundle with the app
    substituteInPlace node_modules/@oclif/dev-cli/lib/tarballs/node.js --replace-fail \
        'async function fetchNodeBinary({ nodeVersion, output, platform, arch, tmp }) {' \
        'async function fetchNodeBinary({ nodeVersion, output, platform, arch, tmp }) { return;'

    # manually place prebuilt `node-datachannel` archive into its place, since we used '--ignore-scripts'
    ln -s ${nodeDatachannelPrebuilt} node_modules/node-datachannel/build

    cp -r ${overridesNodeModules}/node_modules overrides/js/node_modules

    # don't run `npm ci` in `overrides/js` since we already copied node_modules into the directory
    substituteInPlace prepare.ts --replace-fail "'ci', '--production'" "'--version'"

    patchShebangs *.sh
  '';

  preBuild = ''
    npm run build:src
  '';

  npmBuildScript = "build:release";

  installPhase = ''
    runHook preInstall

    # we don't actually use any of the generated tarballs, we just copy from the tmp directory, since that's easier
    mkdir -p $out/share/httptoolkit-server
    cp -r build/tmp/httptoolkit-server/* -r $out/share/httptoolkit-server

    # remove unneeded executables
    rm -r $out/share/httptoolkit-server/bin/httptoolkit-server*

    # since `oclif-dev pack` ran `npm install` again, we need to place the prebuilt binary here again
    ln -s ${nodeDatachannelPrebuilt} $out/share/httptoolkit-server/node_modules/node-datachannel/build

    # disable updating functionality
    substituteInPlace $out/share/httptoolkit-server/node_modules/@oclif/plugin-update/lib/commands/update.js \
        --replace-fail "await this.skipUpdate()" "'cannot update nix based package'"

    # the app determines if it's in production by checking if HTTPTOOLKIT_SERVER_BINPATH is set to anything
    makeWrapper $out/share/httptoolkit-server/bin/run $out/bin/httptoolkit-server \
        --set HTTPTOOLKIT_SERVER_BINPATH dummy \
        --prefix PATH : ${lib.makeBinPath [ nss.tools ]}

    runHook postInstall
  '';

  passthru = {
    inherit nodeDatachannelPrebuilt;
  };
  meta = {
    description = "Backend for HTTP Toolkit";
    homepage = "https://httptoolkit.com/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "httptoolkit-server";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
