{
  lib,
  stdenv,
  fetchurl,
  libx11,
  libxext,
  libxrandr,
  libxrender,
  xorgproto,
  config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evilwm";
  version = "1.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://www.6809.org.uk/evilwm/evilwm-${finalAttrs.version}.tar.gz";
    hash = "sha256-YQSFJBPm1QZpNh3K3aWiXTnisrDJWmOEAiyQWVeidA8=";
  };

  buildInputs = [
    libx11
    libxext
    libxrandr
    libxrender
    xorgproto
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace /usr $out \
      --replace "CC = gcc" "#CC = gcc"
  '';

  # Allow users to set their own list of patches
  patches = config.evilwm.patches or [ ];

  meta = {
    homepage = "http://www.6809.org.uk/evilwm/";
    description = "Minimalist window manager for the X Window System";
    license = {
      shortName = "evilwm";
      fullName = "Custom, inherited from aewm and 9wm";
      url = "https://www.6809.org.uk/evilwm/";
      free = true;
    }; # like BSD/MIT, but Share-Alike'y; See README.
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "evilwm";
  };
})
