{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "c2FmZQ";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "c2FmZQ";
    rev = "v${version}";
    hash = "sha256-SBCUOQpV03kZu6nHuwTUd8gyKeK+XAthZ+H7IRYFjdM=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  sourceRoot = "${src.name}/c2FmZQ";

  vendorHash = "sha256-jyos/CNQyuatq4KL2nqCPtRuMQLZMB35VECiKQhq4go=";

  subPackages = [
    "c2FmZQ-client"
    "c2FmZQ-server"
  ];

  passthru.tests = { inherit (nixosTests) c2fmzq; };

  meta = {
    description = "Securely encrypt, store, and share files, including but not limited to pictures and videos";
    homepage = "https://github.com/c2FmZQ/c2FmZQ";
    license = lib.licenses.gpl3Only;
    mainProgram = "c2FmZQ-server";
    maintainers = with lib.maintainers; [ hmenke ];
    platforms = lib.platforms.linux;
  };
}
