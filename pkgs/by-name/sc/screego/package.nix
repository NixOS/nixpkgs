{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  stdenv,
}:
let

  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "screego";
    repo = "server";
    rev = "v${version}";
    hash = "sha256-xWy7aqpUznIYeBPqdpYdRMJxxfiPNa4JmjS3o5i3xxY=";
  };

  ui = stdenv.mkDerivation {
    pname = "screego-ui";
    inherit version;

    src = src + "/ui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/ui/yarn.lock";
      hash = "sha256-JPSbBUny5unUHVkaVGlHyA90IpT9ahcSmt9R1hxERRk=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];

    preConfigure = ''
      export HOME=$(mktemp -d)
    '';

    installPhase = ''
      cp -r build $out
    '';

  };

in

buildGoModule rec {
  inherit src version;

  pname = "screego-server";

  vendorHash = "sha256-vx7CpHUPQlLEQGxdswQJI1SrfSUwPlpNcb7Cq81ZOBQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commitHash=${src.rev}"
    "-X=main.mode=prod"
  ];

  postPatch = ''
    mkdir -p ./ui
    cp -r "${ui}" ./ui/build
  '';

  postInstall = ''
    mv $out/bin/server $out/bin/screego
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Screen sharing for developers";
    homepage = "https://screego.net";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pinpox ];
    mainProgram = "screego";
  };
}
