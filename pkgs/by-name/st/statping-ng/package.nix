{
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
  go-rice,
  lib,
  nodejs,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
}:
let
  version = "0.93.0";

  src = fetchFromGitHub {
    owner = "statping-ng";
    repo = "statping-ng";
    tag = "v${version}";
    hash = "sha256-VVM3Jyahs0OQuHiF/r+U9vq9TBOFOtuTzBurAhR1Dhc=";
  };

  frontend = stdenv.mkDerivation {
    pname = "statping-ng-frontend";
    inherit version;
    src = "${src}/frontend";

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/frontend/yarn.lock";
      hash = "sha256-e8GyKIJ0RopRliVMVrY8eEd6Qx/gTKbW3biPCSqbRrQ=";
    };

    nativeBuildInputs = [
      nodejs
      yarnConfigHook
      yarnBuildHook
    ];

    preBuild = ''
      export NODE_OPTIONS=--openssl-legacy-provider
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -rt "$out" dist/* src/assets/scss public/robots.txt

      runHook postInstall
    '';
  };
in
buildGoModule rec {
  pname = "statping-ng";
  inherit version src;

  proxyVendor = true;
  vendorHash = "sha256-ZcNOI5/Fs7/U8/re89YpJ3qlMaQStLrrNHXiHuBQwQk=";

  postPatch = ''
    ln -s "${frontend}" source/dist
  '';

  nativeBuildInputs = [
    go-rice
  ];

  preBuild = ''
    (cd source && rice embed-go)
  '';

  subPackages = [
    "cmd/"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  tags = [
    "netgo"
    "ousergo"
  ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/cmd $out/bin/statping-ng
    $out/bin/statping-ng version | grep ${version} > /dev/null
  '';

  meta = {
    description = "Status Page for monitoring your websites and applications with beautiful graphs, analytics, and plugins";
    homepage = "https://github.com/statping-ng/statping-ng";
    changelog = "https://github.com/statping-ng/statping-ng/releases/tag/v${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      FKouhai
    ];
    platforms = lib.platforms.linux;
    mainProgram = "statping-ng";
  };
}
