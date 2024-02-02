{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "c2FmZQ";
  version = "0.4.18";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "c2FmZQ";
    rev = "v${version}";
    hash = "sha256-CWtQMXICCyuXbknR1Z2sLe7GyqN0F2sQGtiTnqppnVA=";
  };

  ldflags = [ "-s" "-w" ];

  sourceRoot = "source/c2FmZQ";

  vendorHash = "sha256-cTXSFwWGHV2QJM4mX/Z+ZxCXKwr+59lEPvJa/PTA1wU=";

  subPackages = [ "c2FmZQ-client" "c2FmZQ-server" ];

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
