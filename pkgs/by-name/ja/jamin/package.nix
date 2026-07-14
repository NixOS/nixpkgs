{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  fftwFloat,
  gtk3,
  ladspaPlugins,
  libjack2,
  liblo,
  libxml2,
  autoconf,
  automake,
  intltool,
  libtool,
  makeWrapper,
  pkg-config,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jamin";
  version = "0.98.9-unstable-2015-01-14";

  src = fetchgit {
    url = "https://git.code.sf.net/p/jamin/code";
    rev = "199091a6e3709e2890eaf2c8b4e57c6749776cdc";
    hash = "sha256-wiIBymvpPxY+z/nZi+dH0hXEuhO5FYQjon6VfJaTwC0=";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/j/jamin/0.98.9~git20170111~199091~repack1-3/debian/patches/gcc15.patch";
      hash = "sha256-dH0NI12Xfw9Rl7Iwm4QzDvXIHT7XzBC8Ly0lQOpDD84=";
    })
    # https://github.com/bendlas/jamin/commit/a6498278654792d46ebef4f918b8a1c7b663a2d9.patch
    ./fix-crash.patch
  ];

  postPatch = ''
    patchShebangs --build controller/xml2c.pl
    # for whatever reason the default config file is gzipped
    mv examples/default.jam{,.gz}
    gunzip examples/default.jam.gz
  '';

  preConfigure = "./autogen.sh";

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
    pkg-config
    makeWrapper
  ]
  ++ (with perlPackages; [
    perl
    XMLParser
  ]);

  buildInputs = [
    fftwFloat
    gtk3
    ladspaPlugins
    libjack2
    liblo
    libxml2
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #     ld: jamin-preferences.o:/build/jamin-0.95.0/src/hdeq.h:64: multiple definition of
  #       `l_notebook1'; jamin-callbacks.o:/build/jamin-0.95.0/src/hdeq.h:64: first defined here
  # `incompatible-pointer-types` fixes build on GCC 14, otherwise fails with:
  #   error: passing argument 4 of 'lo_server_thread_add_method' from incompatible pointer type
  env.NIX_CFLAGS_COMPILE = "-fcommon -Wno-error=incompatible-pointer-types";

  postInstall = ''
    wrapProgram $out/bin/jamin --set LADSPA_PATH ${ladspaPlugins}/lib/ladspa
  '';

  meta = {
    homepage = "https://jamin.sourceforge.net";
    description = "JACK Audio Mastering interface";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.nico202 ];
    platforms = lib.platforms.linux;
  };
})
