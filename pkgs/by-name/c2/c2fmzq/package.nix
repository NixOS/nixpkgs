{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "c2FmZQ";
  version = "0.4.25";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "c2FmZQ";
    rev = "v${version}";
    hash = "sha256-1c2C+BVgf7NumOoCCMfGFpn1qwQ2V4524aG5yZO98vI=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  sourceRoot = "${src.name}/c2FmZQ";

  vendorHash = "sha256-9eWLg0+HkpwUC+De62Izh3vadV3dnwPpf8ksH8KwGqQ=";

  subPackages = [
    "c2FmZQ-client"
    "c2FmZQ-server"
  ];

  passthru.tests = { inherit (nixosTests) c2fmzq; };

  meta = with lib; {
    description = "Securely encrypt, store, and share files, including but not limited to pictures and videos";
    homepage = "https://github.com/c2FmZQ/c2FmZQ";
    license = licenses.gpl3Only;
    mainProgram = "c2FmZQ-server";
    maintainers = with maintainers; [ hmenke ];
    platforms = platforms.linux;
  };
}
