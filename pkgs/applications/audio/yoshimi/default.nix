{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, boost
, cairo
, cmake
, fftwSinglePrec
, fltk
, libGLU
, libjack2
, libsndfile
, libXdmcp
, lv2
, minixml
, pcre
, pkg-config
, readline
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "yoshimi";
<<<<<<< HEAD
  version = "2.3.0.2";
=======
  version = "2.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Yoshimi";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-zFwfKy8CVecGhgr48T+eDNHfMdctfrNGenc/XJctyw8=";
  };

  sourceRoot = "${src.name}/src";
=======
    hash = "sha256-zVIOHm84wx6ZFK0seS9fWZfujDz259AXTv7zljbwrUk=";
  };

  sourceRoot = "source/src";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    substituteInPlace Misc/Config.cpp --replace /usr $out
    substituteInPlace Misc/Bank.cpp --replace /usr $out
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    alsa-lib
    boost
    cairo
    fftwSinglePrec
    fltk
    libGLU
    libjack2
    libsndfile
    libXdmcp
    lv2
    minixml
    pcre
    readline
    xorg.libpthreadstubs
    zlib
  ];

  cmakeFlags = [ "-DFLTK_MATH_LIBRARY=${stdenv.cc.libc}/lib/libm.so" ];

  meta = with lib; {
    description = "High quality software synthesizer based on ZynAddSubFX";
    longDescription = ''
      Yoshimi delivers the same synthesizer capabilities as
      ZynAddSubFX along with very good Jack and Alsa midi/audio
      functionality on Linux
    '';
    homepage = "https://yoshimi.github.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
