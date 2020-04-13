{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "11x4y3ah9f7mv9jssws95sw7rd20fxwdh11mrhcb4vwk59cmqsjz";
  };

  cargoSha256 = "06zv3li14sg4a8bgj38zzx576ggm32ss0djmys1g0h5a0nxaaqfx";

  checkPhase = "cargo test -- --skip test_single_huge_payload";

  meta = with lib; {
    description = "A daemon for managing long running shell commands";
    homepage = "https://github.com/Nukesor/pueue";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
