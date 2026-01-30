{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "small";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "alandefreitas";
    repo = "small";
    tag = "v${version}";
    hash = "sha256-+aPieFls2u2A57CKQz/q+ZqGjNyscDlWDryAp3VM1Lk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/alandefreitas/small";
    description = "C++ small containers";
    license = with lib.licenses; [ boost ];
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
