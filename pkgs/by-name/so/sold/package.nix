{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "sold";
  version = "0-unstable-2024-02-22";

  src = fetchFromGitHub {
    owner = "bluewhalesystems";
    repo = pname;
    rev = "a52e8b37661562c866a579ab1164f94694f479a5";
    sha256 = "0iyrgz0ay2453rqrlvxsrla0998l8yq6q3xyqqw5icfvh05ld8i8";
  };

  buildInputs = [ openssl ];
  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;

  meta = {
    description = "A fork of mold, a faster drop-in replacement for existing Unix linkers, with support for iOS and MacOS";
    license = lib.licenses.mit;
    homepage = "https://github.com/bluewhalesystems/sold";
    maintainers = with lib.maintainers; [ elise ];
    platforms = lib.platforms.all;
    mainProgram = "ld64.sold";
  };
}
