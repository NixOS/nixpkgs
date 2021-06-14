{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "workstyle";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "pierrechevalier83";
    repo = pname;
    rev = "43b0b5bc0a66d40289ff26b8317f50510df0c5f9";
    sha256 = "0f4hwf236823qmqy31fczjb1hf3fvvac3x79jz2l7li55r6fd8hn";
  };

  cargoSha256 = "1hy68wvsxncsy4yx4biigfvwyq18c7yp1g543c6nca15cdzs1c54";

  doCheck = false; # No tests

  meta = with lib; {
    description = "Sway workspaces with style";
    homepage = "https://github.com/pierrechevalier83/workstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
