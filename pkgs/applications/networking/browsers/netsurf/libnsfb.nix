<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, SDL
, pkg-config
, buildsystem
, uilib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnsfb";
  version = "0.2.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnsfb-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-vkRso+tU35A/LamDEdEH11dM0R9awHE+YZFW1NGeo5o=";
  };

  nativeBuildInputs = [ pkg-config ];

=======
{ lib, stdenv, fetchurl, pkg-config
, uilib, SDL
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libnsfb";
  version = "0.2.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-vkRso+tU35A/LamDEdEH11dM0R9awHE+YZFW1NGeo5o=";
  };

  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ SDL buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "TARGET=${uilib}"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libnsfb/";
    description = "Netsurf framebuffer abstraction library";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
=======
  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "Netsurf framebuffer abstraction library";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
