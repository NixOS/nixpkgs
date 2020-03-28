{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yx69pwdal0p5dfhabjdns9z6z3fa41wh7bxa4dpsjx37ziglcsp";
  };

  cargoSha256 = "1ksr5fw9p3j1bnlgfimb5nsryb4si8ic2x4prsra1mwkc91hr7x3";

  checkPhase = "cargo test -- --skip test_single_huge_payload";

  meta = with lib; {
    description = "A daemon for managing long running shell commands";
    homepage = "https://github.com/Nukesor/pueue";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
