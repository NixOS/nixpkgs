{
  lib,
  callPackage,
  stdenv,
  nodejs,
  fetchFromGitHub,
  yarn-berry_4,
  elmPackages,
  writeScript,
  buildGoModule,
  postgresql,
  nixosTests,
  withWebUI ? true,
}:
let
  version = "7.14.2";
  meta = {
    mainProgram = "concourse";
    homepage = "https://concourse-ci.org";
    description = "Container-based automation system written in Go";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lenianiva
      lightquantum
    ];
  };

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    tag = "v${version}";
    hash = "sha256-Q+j41QhhibyE+a7iOgMKm2SeXhNV8ek97P014Wje9NQ=";
  };
  yarn-berry = yarn-berry_4;

  webui = stdenv.mkDerivation (finalAttrs: {
    pname = "concourse-webui";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      yarn-berry
      yarn-berry.yarnBerryConfigHook
    ];

    env.PUPPETEER_SKIP_DOWNLOAD = true;

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
buildGoModule {
  pname = "concourse";
  vendorHash = "sha256-2busKAFaQYE82XKCAx8BGOMjjs8WzqIxdpz+J45maoc=";
  inherit meta version src;

  subPackages = [
    "cmd/concourse"
  ];
  ldflags = [
    "-s"
    "-w"
    "-X github.com/concourse/concourse.Version=${version}"
  ];

  preBuild = lib.optionalString withWebUI ''
    cp -r ${webui}/public web
  '';

  nativeCheckInputs = [ postgresql ];
  doCheck = true;

  passthru = {
    resource-types = callPackage ./resource-types.nix { inherit version meta; };
    init = callPackage ./init.nix { inherit src version meta; };
    updateScript = callPackage ./update-script.nix { inherit version; };

    tests = nixosTests.concourse;
  };

}
