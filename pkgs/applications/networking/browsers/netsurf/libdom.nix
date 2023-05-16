<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, expat
, pkg-config
=======
{ lib, stdenv, fetchurl, pkg-config, expat
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildsystem
, libparserutils
, libwapcaplet
, libhubbub
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libdom";
  version = "0.4.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libdom-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-mO4HJHHlXiCMmHjlFcQQrUYso2+HtK/L7K0CPzos70o=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    buildsystem
    libhubbub
    libparserutils
    libwapcaplet
  ];
=======
stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libdom";
  version = "0.4.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-mO4HJHHlXiCMmHjlFcQQrUYso2+HtK/L7K0CPzos70o=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    expat
    libhubbub
    libparserutils
    libwapcaplet
    buildsystem ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libdom/";
=======
  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Document Object Model library for netsurf browser";
    longDescription = ''
      LibDOM is an implementation of the W3C DOM, written in C. It is currently
      in development for use with NetSurf and is intended to be suitable for use
      in other projects under a more permissive license.
    '';
<<<<<<< HEAD
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
=======
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
