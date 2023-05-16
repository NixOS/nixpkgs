<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-buildsystem";
  version = "1.9";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/buildsystem-${finalAttrs.version}.tar.gz";
    hash = "sha256-k4QeMUpoggmiC4dF8GU5PzqQ8Bvmj0Xpa8jS9KKqmio=";
=======
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "buildsystem";
  version = "1.9";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}.tar.gz";
    sha256 = "sha256-k4QeMUpoggmiC4dF8GU5PzqQ8Bvmj0Xpa8jS9KKqmio=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf browser shared build system";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vrthra AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf browser shared build system";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
