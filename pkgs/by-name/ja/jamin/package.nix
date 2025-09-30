{
  lib,
  stdenv,
  fetchurl,
  fftwFloat,
  gtk2,
  ladspaPlugins,
  libjack2,
  liblo,
  libxml2,
  makeWrapper,
  pkg-config,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.95.0";
  pname = "jamin";

  src = fetchurl {
    url = "mirror://sourceforge/jamin/jamin-${finalAttrs.version}.tar.gz";
    hash = "sha256-di/uiGgvJ4iORt+wE6mrXnmFM7m2dkP/HXdgUBk5uzw=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    fftwFloat
    gtk2
    ladspaPlugins
    libjack2
    liblo
    libxml2
  ]
  ++ (with perlPackages; [
    perl
    XMLParser
  ]);

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
