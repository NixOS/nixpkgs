{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  freetype,
  harfbuzz,
  fribidi,
}:

stdenv.mkDerivation rec {
  pname = "libraqm";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "HOST-Oman";
    repo = "libraqm";
    rev = "v${version}";
    sha256 = "sha256-URW29aEONbMN/DQ6mkKksnwtbIL+SGm5VvKsC9h5MH4=";
  };

  buildInputs = [
    freetype
    harfbuzz
    fribidi
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Library for complex text layout";
    homepage = "https://github.com/HOST-Oman/libraqm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Library for complex text layout";
    homepage = "https://github.com/HOST-Oman/libraqm";
    license = licenses.mit;
    maintainers = with maintainers; [ sifmelcara ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
