{
  lib,
  nodejs_20,
  buildNpmPackage,
  fetchFromGitHub,
  writeShellScriptBin,
  nss,
  cmake,
  pkg-config,
  openssl,
  libdatachannel,
}:

let
  nodejs = nodejs_20;
  buildNpmPackage' = buildNpmPackage.override { inherit nodejs; };

  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "httptoolkit";
    repo = "httptoolkit-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-S4Io4X5Hlvm/5HoKIQ/OTor9jZvMz6me5RyfZ8FwOdM=";
  };

  overridesNodeModules = buildNpmPackage' {
    pname = "httptoolkit-server-overrides-node-modules";
    inherit version src;
    sourceRoot = "${src.name}/overrides/js";

    npmDepsHash = "sha256-GRN6ua3FY1AE61bB7PM2wgbKPZI/zJeXa5HOOh/2N2Y=";

    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/node_modules
    '';
  };

  nodeDatachannel = buildNpmPackage' {
    pname = "node-datachannel";
    version = "0.4.3";

    src = fetchFromGitHub {
      owner = "murat-dogan";
      repo = "node-datachannel";
      rev = "refs/tags/v${nodeDatachannel.version}";
      hash = "sha256-BlfeocqSG+pqbK0onnCf0VKbQw8Qq4qMxhAcfGlFYR8=";
    };

    npmFlags = [ "--ignore-scripts" ];

    makeCacheWritable = true;

    npmDepsHash = "sha256-pgcOOjiuWKlpD+WJyPj/c9ZhDjYuEnybpLS/BPmzeFM=";

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      openssl
      libdatachannel
    ];

    dontUseCmakeConfigure = true;

    env.NIX_CFLAGS_COMPILE = "-I${nodejs}/include/node";
    env.CXXFLAGS = "-include stdexcept"; # for GCC13

    preBuild = ''
      # don't use static libs and don't use FetchContent
      substituteInPlace CMakeLists.txt \
          --replace-fail 'OPENSSL_USE_STATIC_LIBS TRUE' 'OPENSSL_USE_STATIC_LIBS FALSE' \
          --replace-fail 'if(NOT libdatachannel)' 'if(false)' \
          --replace-fail 'datachannel-static' 'datachannel'

      # don't fetch node headers
      substituteInPlace node_modules/cmake-js/lib/dist.js \
          --replace-fail '!this.downloaded' 'false'

      npm rebuild --verbose
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 build/Release/*.node -t $out/build/Release
      runHook postInstall
    '';
  };
in
buildNpmPackage' {
  pname = "httptoolkit-server";
  inherit version src;

  patches = [ ./only-build-for-one-platform.patch ];

  npmDepsHash = "sha256-njSNdpo+CIfS9LTnshawJ7297tFc8ssjUqJcHk8kBZE=";

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

    # manually place our prebuilt `node-datachannel` binary into its place, since we used '--ignore-scripts'
    ln -s ${nodeDatachannel}/build node_modules/node-datachannel/build

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
    ln -s ${nodeDatachannel}/build $out/share/httptoolkit-server/node_modules/node-datachannel/build

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
    inherit nodeDatachannel;
  };

  meta = {
    description = "Backend for HTTP Toolkit";
    homepage = "https://httptoolkit.com/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "httptoolkit-server";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}
