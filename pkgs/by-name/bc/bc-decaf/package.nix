{
  cmake,
  fetchFromGitLab,
  lib,
  python3,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "bc-decaf";
  version = "linphone-5.2.6";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    python3
  ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "decaf";
    rev = "63ad363f92eb50bc09ed3be8574f84650ed377a9";
    sha256 = "sha256-KgjRSif/aG5AITXgH4aDsFdJ0moj/mT9z9d2iEVoioI=";
  };

  # Do not build static libraries and do not enable -Werror
  cmakeFlags = [
    "-DENABLE_STATIC=NO"
    "-DENABLE_STRICT=NO"
  ];

  meta = with lib; {
    description = "Elliptic curve library supporting Ed448-Goldilocks and Curve25519. Belledonne Communications' fork for Linphone";
    homepage = "https://gitlab.linphone.org/BC/public/bctoolbox";
    license = licenses.mit;
    maintainers = with maintainers; [ thibaultlemaire ];
    platforms = platforms.linux;
  };
}
