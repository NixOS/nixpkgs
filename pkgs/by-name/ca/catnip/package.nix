{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  portaudio,
  testers,
  catnip,
}:

buildGoModule rec {
  pname = "catnip";
  version = "1.8.7";

  src = fetchFromGitHub {
    owner = "noriah";
    repo = "catnip";
    rev = "v${version}";
    hash = "sha256-M9VGpDsBambe9kXyEgDg53pKOSL2zH1ugfSbRgAiaCo=";
  };

  vendorHash = "sha256-Hj453+5fhbUL6YMeupT5D6ydaEMe+ZQNgEYHtCUtTx4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    portaudio
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = catnip;
    };
  };

  meta = with lib; {
    description = "Terminal audio visualizer for linux/unix/macOS/windows";
    homepage = "https://github.com/noriah/catnip";
    changelog = "https://github.com/noriah/catnip/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "catnip";
  };
}
