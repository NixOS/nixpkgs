{
  src,
  version,
  config,
  lib,
  pkgs,
  stdenv,
  nodejs,
  yarn-berry_4,
  elmPackages,
  writeScript,
  buildGo125Module,
  withWebUI ? true,
  ...
}:
let
  yarn-berry = yarn-berry_4;
  buildGoModule = buildGo125Module;

  webui = stdenv.mkDerivation (finalAttrs: {
    pname = "concourse-webui";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      yarn-berry
      yarn-berry.yarnBerryConfigHook
    ];

    env = {
      PUPPETEER_SKIP_DOWNLOAD = "true";
    };

    missingHashes = ./missing-hashes.json;
    offlineCache = yarn-berry.fetchYarnBerryDeps {
      inherit (finalAttrs) src missingHashes;
      hash = "sha256-vVfLdJSXfYlWiLXKJ0ywSnBMhpJbFrikfccbX/XJlzU=";
    };

    postConfigure = elmPackages.fetchElmDeps {
      elmPackages = import ./elm-srcs.nix;
      elmVersion = elmPackages.elm.version;
      registryDat = ./registry.dat;
    };

    preBuild =
      let
        # NOTE the node wrapper is required because yarn 2+ always executes elm as a node script
        elmWrapperScript = writeScript "elm-wrapper" ''
          #!/usr/bin/env node

          var child_process = require('child_process');
          child_process.spawn('${lib.getExe elmPackages.elm}', process.argv.slice(2), { stdio: 'inherit' })
            .on('exit', process.exit);
        '';
      in
      ''
        cp ${elmWrapperScript} node_modules/elm/bin/elm
      '';

    buildPhase = ''
      runHook preBuild
      yarn run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r web/public $out
      runHook postInstall
    '';
  });
in

buildGoModule rec {
  pname = "concourse-executable";
  inherit version;
  vendorHash = "sha256-2busKAFaQYE82XKCAx8BGOMjjs8WzqIxdpz+J45maoc=";
  inherit src;

  subPackages = [
    "cmd/concourse"
  ];
  ldflags = [
    "-s"
    "-w"
    "-X github.com/concourse/concourse.Version=${version}"
  ];

  preBuild = lib.optionals withWebUI ''
    cp -r ${webui}/public web
  '';

  doCheck = false; # Tests broken
}
