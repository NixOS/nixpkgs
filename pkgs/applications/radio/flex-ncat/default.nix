{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flex-ncat";
  version = "0.0-20210420.0";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    rev = "v${version}";
    sha256 = "0wrdmlp9rrr4n0g9pj0j20ddskllyr59dr3p5fm9z0avkncn3a0m";
  };

  vendorSha256 = "0npzhvpyaxvfaivycnscvh45lp0ycdg9xrlfm8vhfr835yj2adiv";

  meta = with lib; {
    homepage = "https://github.com/kc2g-flex-tools/nCAT";
    description = "FlexRadio remote control (CAT) via hamlib/rigctl protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
  };
}
