{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "matrix-federation-tester";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-federation-tester";
    tag = "v${version}";
    hash = "sha256-jf33eyjt4C5E1ite1NKkiQAwvB7zB9NQHdr+w/6nloQ=";
  };

  vendorHash = "sha256-UQUtD1zJaJf8UyRGUFSUHAB3OPfNFuVdc/oPUQrC6Do=";
  strictDeps = true;

  meta = {
    mainProgram = "matrix-federation-tester";
    homepage = "https://github.com/matrix-org/matrix-federation-tester";
    description = "Tester for matrix federation written in golang";
    maintainers = with lib.maintainers; [ ma27 ];
  };
}
