<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, perl
, pkg-config
=======
{ lib, stdenv, fetchurl, pkg-config, perl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildsystem
, libparserutils
, libwapcaplet
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libcss";
  version = "0.9.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libcss-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-0tzhbpM5Lo1qcglCDUfC1Wo4EXAaDoGnJPxUHGPTxtw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    perl
    buildsystem
    libparserutils
    libwapcaplet
  ];
=======
stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libcss";
  version = "0.9.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-0tzhbpM5Lo1qcglCDUfC1Wo4EXAaDoGnJPxUHGPTxtw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    perl
    libparserutils
    libwapcaplet
    buildsystem ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

<<<<<<< HEAD
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-fallthrough"
    "-Wno-error=maybe-uninitialized"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libcss/";
=======
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=implicit-fallthrough" "-Wno-error=maybe-uninitialized" ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Cascading Style Sheets library for netsurf browser";
    longDescription = ''
      LibCSS is a CSS parser and selection engine. It aims to parse the forward
      compatible CSS grammar. It was developed as part of the NetSurf project
      and is available for use by other software, under a more permissive
      license.
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
