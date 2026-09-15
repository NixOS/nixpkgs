{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  openal,
  freealut,
  libvorbis,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spacezero";
  version = "0.86.01";

  src = fetchurl {
    url = "mirror://sourceforge/spacezero/spacezero%20${lib.versions.major finalAttrs.version}.${lib.versions.minor finalAttrs.version}/spacezero-${finalAttrs.version}.tar.gz";
    hash = "sha256-hYinMFHjXjXm2RI7W+s581dGI8ZOjcTzO05PMAO3MpY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  #Upstream hardcodes /usr/bin/gcc and also has header issues that break
  #with modern compilers
  patches = [ ./fix-build.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk2
    openal
    freealut
    libvorbis
    libx11
  ];

  #Avoids upstream's default "all" target which runs "dirs" and creates
  # $HOME/.spacezero during build step. We need only bin/ directory.
  preBuild = ''
    mkdir -p bin
  '';

  buildFlags = [
    "spacezero"
    "INSTALL_DATA_DIR=$(out)/share/spacezero"
  ];

  installFlags = [
    "INSTALL_DIR=$(out)/bin"
    "INSTALL_DATA_DIR=$(out)/share/spacezero"
  ];

  meta = {
    description = "A RTS 2D space combat, single and multiplayer net game";
    homepage = "https://spacezero.sourceforge.net/";
    downloadPage = "https://sourceforge.net/projects/spacezero/";
    mainProgram = "spacezero";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
