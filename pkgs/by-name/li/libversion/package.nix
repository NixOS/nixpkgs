{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "libversion";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = version;
    hash = "sha256-USgSwAdRHEepq9ZTDHVWkPsZjljfh9sEWOZRfu0H7Go=";
  };

  nativeBuildInputs = [ cmake ];

  checkTarget = "test";
  doCheck = true;

  meta = with lib; {
    description = "Advanced version string comparison library";
    homepage = "https://github.com/repology/libversion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
