{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "c2FmZQ";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "c2FmZQ";
    rev = "v${version}";
    hash = "sha256-xrQBL/Xjzsg0jZ7cFuDfjCQhmt/dTD8FoCSlw0sX5MQ=";
  };

  ldflags = [ "-s" "-w" ];

  sourceRoot = "source/c2FmZQ";

  vendorHash = "sha256-Hz6P+ptn1i+8Ek3pp8j+iB8NN5Xks50jyZuT8Ullxbo=";

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
