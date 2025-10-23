{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "c2FmZQ";
  version = "0.4.32";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "c2FmZQ";
    rev = "v${version}";
    hash = "sha256-1FIGA4pmMb4o6H6GmsiSt/UG2PaC6QR3+L9QKhT8sJQ=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  sourceRoot = "${src.name}/c2FmZQ";

  vendorHash = "sha256-usMM9YU+xW+6X5W6rCOtXeggK/WCcik0s+4dFAfbozM=";

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
