{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  allegro,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "dumb";
  version = "2.0.3";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    allegro
    SDL2
  ];

  src = fetchFromGitHub {
    owner = "kode54";
    repo = "dumb";
    rev = version;
    sha256 = "1cnq6rb14d4yllr0yi32p9jmcig8avs3f43bvdjrx4r1mpawspi6";
  };

  cmakeFlags = [
    "-DBUILD_EXAMPLES='OFF'"
  ];

  meta = {
    homepage = "https://github.com/kode54/dumb";
    description = "Module/tracker based music format parser and player library";
    license = lib.licenses.free; # Derivative of GPL
    maintainers = with lib.maintainers; [ Madouura ];
    platforms = lib.platforms.all;
  };
}
