{
  nodejs,
  elmPackages,
  yarn-berry_4,
  buildGo125Module,
  fetchFromGitHub,
  lib,
  stdenv,
  writeScript,
  writeShellScript,
  nix-update,
  elm2nix,
  nixfmt,
  nixosTests,
  dockerTools,
}:

let
  version = "7.14.1";

  yarn-berry = yarn-berry_4;
  buildGoModule = buildGo125Module;
  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    hash = "sha256-Q+j41QhhibyE+a7iOgMKm2SeXhNV8ek97P014Wje9NQ=";
  };
in
stdenv.mkDerivation rec {
  pname = "concourse";
  meta = with lib; {
    homepage = "https://concourse-ci.org";
    description = "A container-based automation system written in Go.";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ lenianiva ];
  };
  inherit version src;

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
  executable = buildGoModule rec {
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

    preBuild = ''
      cp -r ${webui}/public web
    '';

    doCheck = false; # Tests broken

  };
  binary-tar = fetchTarball {
    url = "https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-linux-amd64.tgz";
    sha256 = "0f0kblsig0d3j4swynxj16pa5iycxa92bd4pm5vzxqr3nn4w2ncl";
  };
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp ${executable}/bin/concourse $out/bin/
    cp -r ${binary-tar}/resource-types $out/resource-types
  '';

  passthru = {
    tests = nixosTests.concourse;
    updateScript = writeShellScript "update-concourse" ''
      set -eu -o pipefail

      # Update version, src and npm deps
      ${lib.getExe nix-update} "$UPDATE_NIX_ATTR_PATH"

      # Update elm deps
      cp "$(nix-build -A "$UPDATE_NIX_ATTR_PATH".src)/web/elm/elm.json" elm.json
      trap 'rm -rf elm.json registry.dat &> /dev/null' EXIT
      ${lib.getExe elm2nix} convert > pkgs/by-name/co/concourse/elm-srcs.nix
      ${lib.getExe nixfmt} pkgs/by-name/co/concourse/elm-srcs.nix
      ${lib.getExe elm2nix} snapshot
      cp registry.dat pkgs/by-name/co/concourse/registry.dat
    '';
  };

}
