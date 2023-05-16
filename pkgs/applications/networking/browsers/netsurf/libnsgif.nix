<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, pkg-config
, buildPackages
, buildsystem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnsgif";
  version = "0.2.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnsgif-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-nq6lNM1wtTxar0UxeulXcBaFprSojb407Sb0+q6Hmks=";
=======
{ lib, stdenv, fetchurl, pkg-config, buildPackages
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libnsgif";
  version = "0.2.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-nq6lNM1wtTxar0UxeulXcBaFprSojb407Sb0+q6Hmks=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "BUILD_CC=$(CC_FOR_BUILD)"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libnsgif/";
    description = "GIF Decoder for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
=======
  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "GIF Decoder for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
