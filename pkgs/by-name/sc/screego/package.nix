{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  stdenv,
}:
let

  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "screego";
    repo = "server";
    rev = "v${version}";
    hash = "sha256-wFLoReqzLx6PEW/u9oz7VIYKtJkmwGTneeB6Ysgse7Q=";
  };

  ui = stdenv.mkDerivation {
    pname = "screego-ui";
    inherit version;

    src = src + "/ui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/ui/yarn.lock";
      hash = "sha256-yjHxyKEqXMxYsm+KroPB9KulfqYSOU/7ghbKnlSFrd0=";
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

buildGo123Module rec {
  inherit src version;

  pname = "screego-server";

  vendorHash = "sha256-zMb8MLS0KhwYNpfVeNMD9huEcpyyrZD0QAPmBNxMcQU=";

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
