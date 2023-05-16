<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, gperf
, pkg-config
=======
{ lib, stdenv, fetchurl, pkg-config, gperf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildsystem
, libdom
, libhubbub
, libparserutils
, libwapcaplet
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libsvgtiny";
  version = "0.1.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libsvgtiny-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-LA3PlS8c2ILD6VQB75RZ8W27U8XT5FEjObL563add4E=";
  };

  nativeBuildInputs = [
    gperf
    pkg-config
  ];

  buildInputs = [
    buildsystem
=======
stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libsvgtiny";
  version = "0.1.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-LA3PlS8c2ILD6VQB75RZ8W27U8XT5FEjObL563add4E=";
  };

  nativeBuildInputs = [ pkg-config gperf ];
  buildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libdom
    libhubbub
    libparserutils
    libwapcaplet
<<<<<<< HEAD
  ];
=======
    buildsystem ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libsvgtiny/";
    description = "NetSurf SVG decoder";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
=======
  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "NetSurf SVG decoder";
    license = licenses.mit;
    maintainers = [ maintainers.samueldr maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
