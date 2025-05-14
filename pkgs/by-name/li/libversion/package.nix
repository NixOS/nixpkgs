{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "libversion";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = version;
    hash = "sha256-REmXD0NFd7Af01EU/f2IGoTKiju6ErTI7WUinvrAzaA=";
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
