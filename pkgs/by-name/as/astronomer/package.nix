{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "astronomer";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = "astronomer";
    rev = "v${version}";
    hash = "sha256-4hUfJI2BRZl3Trk8F2qLZAyA57kq0oW9/e13atj/BVg=";
  };

  vendorHash = "sha256-EOtpZPIrAVMPIZGnkZoNs7ovaR7Ts3dJsFLXClIoNVI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to detect illegitimate stars from bot accounts on GitHub projects";
    homepage = "https://github.com/Ullaakut/astronomer";
    changelog = "https://github.com/Ullaakut/astronomer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "astronomer";
  };
}
