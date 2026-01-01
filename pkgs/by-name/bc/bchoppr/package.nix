{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cairo,
  libX11,
  lv2,
}:

stdenv.mkDerivation rec {
  pname = "bchoppr";
  version = "1.12.6";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "bchoppr";
    tag = version;
    hash = "sha256-/aLoLUpWu66VKd9lwjli+FZZctblrZUPSEsdYH85HwQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    libX11
    lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/sjaehn/BChoppr";
    description = "Audio stream chopping LV2 plugin";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    homepage = "https://github.com/sjaehn/BChoppr";
    description = "Audio stream chopping LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
