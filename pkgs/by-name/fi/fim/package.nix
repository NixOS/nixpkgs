{
  stdenv,
  fetchurl,
  autoconf,
  automake,
  pkg-config,
  replaceVars,
  lib,
  perl,
  flex,
  bison,
  readline,
  libexif,
  bash,
  buildPackages,
  # SDL depends on Qt, which doesn't cross-compile
  x11Support ? (stdenv.buildPlatform.canExecute stdenv.hostPlatform),
  SDL,
  svgSupport ? true,
  inkscape,
  asciiArtSupport ? true,
  aalib,
  gifSupport ? true,
  giflib,
  tiffSupport ? true,
  libtiff,
  jpegSupport ? true,
  libjpeg,
  pngSupport ? true,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "fim";
  version = "0.7";

  src = fetchurl {
    url = "mirror://savannah/fbi-improved/${pname}-${version}-trunk.tar.gz";
    sha256 = "sha256-/p7bjeZM46DJOQ9sgtebhkNpBPj2RJYY3dMXhzHnNmg=";
  };

  patches = [
    # build tools with a build compiler
    (replaceVars ./native-tools.patch {
      cc_for_build = lib.getExe buildPackages.stdenv.cc;
      # patch context
      FIM_WANT_CUSTOM_HARDCODED_CONSOLEFONT_TRUE = null;
      HAVE_RUNNABLE_TESTS_TRUE = null;
    })
  ];

  postPatch = ''
    patchShebangs --build doc/vim2html.pl
  '';

  nativeBuildInputs = [
    autoconf
    automake
    bison
    flex
    perl
    pkg-config
  ];

  buildInputs =
    [
      flex
      readline
      libexif
      bash
    ]
    ++ lib.optional x11Support SDL
    ++ lib.optional svgSupport inkscape
    ++ lib.optional asciiArtSupport aalib
    ++ lib.optional gifSupport giflib
    ++ lib.optional tiffSupport libtiff
    ++ lib.optional jpegSupport libjpeg
    ++ lib.optional pngSupport libpng;

  configureFlags = [
    # mmap works on all relevant platforms
    "ac_cv_func_mmap_fixed_mapped=yes"
    # system regexp works on all relevant platforms
    "fim_cv_regex_broken=no"
  ];

  env.LIBAA_CONFIG = lib.getExe' (lib.getDev aalib) "aalib-config";
  env.LIBPNG_CONFIG = lib.getExe' (lib.getDev libpng) "libpng-config";
  env.NIX_CFLAGS_COMPILE = lib.optionalString x11Support "-lSDL";

  meta = with lib; {
    description = "Lightweight, highly customizable and scriptable image viewer";
    longDescription = ''
      FIM (Fbi IMproved) is a lightweight, console based image viewer that aims
      to be a highly customizable and scriptable for users who are comfortable
      with software like the VIM text editor or the Mutt mail user agent.
    '';
    homepage = "https://www.nongnu.org/fbi-improved/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
