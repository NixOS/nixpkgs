{ lib
, stdenv
, fetchurl
, pkg-config
, buildsystem
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libutf8proc";
  version = "2.4.0-1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libutf8proc-${finalAttrs.version}-src.tar.gz";
=======
stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libutf8proc";
  version = "2.4.0-1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hash = "sha256-AasdaYnBx3VQkNskw/ZOSflcVgrknCa+xRQrrGgCxHI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "UTF8 Processing library for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
=======
  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "UTF8 Processing library for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
