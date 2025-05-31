{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  bun,
  nodejs-slim_latest,
  nix-update-script,
  withServer ? true,
}:
let
  pname = "cup-docker";
  version = "3.4.0";
  src = fetchFromGitHub {
    owner = "sergi0g";
    repo = "cup";
    tag = "v${version}";
    hash = "sha256-ciH3t2L2eJhk1+JXTqEJSuHve8OuVod7AuQ3iFWmKRE=";
  };
  # inspired by https://github.com/NixOS/nixpkgs/issues/255890#issue-1900964134
  web-node-modules = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "${pname}-web-node-modules";
    inherit version src;
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    sourceRoot = "${finalAttrs.src.name}/web";
    nativeBuildInputs = [
      bun
      nodejs-slim_latest
    ];
    dontConfigure = true;
    buildPhase = ''
      bun install --no-progress --frozen-lockfile
    '';
    dontPatchShebangs = true;
    installPhase = ''
      mkdir -p $out/node_modules
      cp -R ./node_modules $out
    '';
    outputHash = "sha256-RhfH4+mRMqoypk5rxN3ATse5AVhd3mbg4dSmuUWX1t0=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  });
  web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "${pname}-web";
    inherit version src web-node-modules;
    sourceRoot = "${finalAttrs.src.name}/web";
    nativeBuildInputs = [ bun ];
    configurePhase = ''
      runHook preConfigure

      # node modules need to be copied to substitute for reference
      # substitution step cannot be done before otherwise
      # nix complains about unallowed reference in FOD
      cp -R ${web-node-modules}/node_modules .
      # bun installs .bin package with a usr bin env ref to node
      # replace any ref for bin that are used
      substituteInPlace node_modules/.bin/{vite,tsc} \
        --replace-fail "/usr/bin/env node" "${nodejs-slim_latest}/bin/node"

      runHook postConfigure
    '';
    buildPhase = ''
      runHook preBuild
      bun run build
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/dist
      cp -R ./dist $out
      runHook postInstall
    '';
  });
in
rustPlatform.buildRustPackage {
  inherit
    src
    version
    pname
    web
    ;

  cargoHash = "sha256-L9zugOwlPwpdtjV87dT1PH7FAMJYHYFuvfyOfPe5b2k=";

  buildNoDefaultFeatures = true;
  buildFeatures =
    [
      "cli"
    ]
    ++ lib.optional withServer [
      "server"
    ];

  preConfigure = ''
    cp -r ${web}/dist src/static
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "web.web-node-modules"
      "--subpackage"
      "web"
    ];
  };

  meta = {
    description = "a lightweight way to check for container image updates. written in Rust";
    homepage = "https://cup.sergi0g.dev";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    changelog = "https://github.com/sergi0g/cup/releases";
    mainProgram = "cup";
    maintainers = with lib.maintainers; [
      kuflierl
    ];
  };
}
