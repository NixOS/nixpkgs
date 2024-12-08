{ lib
, buildGoModule
, fetchFromGitHub
, testers
, otel-desktop-viewer
, stdenv
, apple-sdk_12
}:

buildGoModule rec {
  pname = "otel-desktop-viewer";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "CtrlSpice";
    repo = "otel-desktop-viewer";
    rev = "v${version}";
    hash = "sha256-kMgcco4X7X9WoCCH8iZz5qGr/1dWPSeQOpruTSUnonI=";
  };

  # https://github.com/CtrlSpice/otel-desktop-viewer/issues/139
  patches = [ ./version-0.1.4.patch ];

  subPackages = [ "..." ];

  vendorHash = "sha256-pH16DCYeW8mdnkkRi0zqioovZu9slVc3gAdhMYu2y98=";

  ldflags = [ "-s" "-w" ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin apple-sdk_12;

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = otel-desktop-viewer;
    command = "otel-desktop-viewer --version";
  };

  meta = with lib; {
    changelog = "https://github.com/CtrlSpice/otel-desktop-viewer/releases/tag/v${version}";
    description = "Receive & visualize OpenTelemtry traces locally within one CLI tool";
    homepage = "https://github.com/CtrlSpice/otel-desktop-viewer";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "otel-desktop-viewer";
  };
}
