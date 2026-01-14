{
  cmake,
  fetchFromGitLab,
  lib,
  python3,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "bc-decaf";
  # version retrieved from `HISTORY.txt`
  version = "1.0.2-unstable-2025-06-25";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    python3
  ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "decaf";
    rev = "e5cc6240690d3ffdfcbdb1e4e851954b789cd5d9";
    sha256 = "sha256-4oZtpdelyKbd2k4LAhtsLkL5Y84C1Qb02fpVywYorr8=";
  };

  # Do not build static libraries and do not enable -Werror
  cmakeFlags = [
    "-DENABLE_STATIC=NO"
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_STRICT=NO"
  ];

  meta = {
    description = "Elliptic curve library supporting Ed448-Goldilocks and Curve25519. Belledonne Communications' fork for Linphone";
    homepage = "https://gitlab.linphone.org/BC/public/external/decaf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      naxdy
    ];
    platforms = lib.platforms.linux;
  };
}
