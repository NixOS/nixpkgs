{ lib, rustPlatform, fetchFromGitHub, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-z+0bSxoLJTK4e5xS4CHZ2hNUI56Ci1gbWJsRcN6ZqZA=";
  };

  cargoSha256 = "sha256-3e5wDne6Idu+kDinHPcAKHfH/d4DrGg90GkiMbyF280=";

  passthru.tests = nixosTests.cntr;

  meta = with lib; {
    description = "A container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
