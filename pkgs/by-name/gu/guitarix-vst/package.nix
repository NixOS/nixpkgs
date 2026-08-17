{
  alsa-lib,
  avahi,
  boost,
  curl,
  fetchFromGitHub,
  fftwFloat,
  freetype,
  glib,
  glibmm,
  lib,
  libsndfile,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  lilv,
  ncurses,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guitarix-vst";
  version = "0.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "guitarix.vst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SuKPTdYt9sFAZGFsf5P6nl4lzTOirOTOeRoCJEMH76w=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace Builds/LinuxMakefile/Makefile \
      --replace-fail '$(shell arch)' '${stdenv.hostPlatform.uname.processor}'
  '';

  nativeBuildInputs = [
    pkg-config
    ncurses
  ];

  buildInputs = [
    alsa-lib
    avahi
    boost
    curl
    fftwFloat
    freetype
    glib
    glibmm
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
    lilv
    libsndfile
  ];

  installFlags = [ "JUCE_VST3DESTDIR=${placeholder "out"}/lib/vst3" ];

  meta = {
    description = "Versatile (guitar) amplifier VST3 plugin";
    homepage = "https://github.com/brummer10/guitarix.vst";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.eymeric ];
    platforms = lib.platforms.linux;
  };
})
