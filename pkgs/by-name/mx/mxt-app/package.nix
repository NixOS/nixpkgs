{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
}:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.46";
=======
  version = "1.45";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-SeP48xdZ43dL28tg7mo8SmObUt3R+8oyETst6yKkhnU=";
=======
    sha256 = "sha256-kMVNakIzqGvT2+7plNsiqPdQ+0zuS7gh+YywF0hA1H4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  hardeningDisable = [ "fortify" ];

<<<<<<< HEAD
  meta = {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = "https://github.com/atmel-maxtouch/mxt-app";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = "https://github.com/atmel-maxtouch/mxt-app";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mxt-app";
  };
}
