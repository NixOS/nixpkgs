<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, perl
, buildsystem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libparserutils";
  version = "0.2.4";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libparserutils-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-MiuuYbMMzt4+MFv26uJBSSBkl3W8X/HRtogBKjxJR9g=";
  };

  buildInputs = [
    perl
    buildsystem
  ];
=======
{ lib, stdenv, fetchurl, perl
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libparserutils";
  version = "0.2.4";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-MiuuYbMMzt4+MFv26uJBSSBkl3W8X/HRtogBKjxJR9g=";
  };

  buildInputs = [ perl buildsystem ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libparserutils/";
    description = "Parser building library for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
=======
  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "Parser building library for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
