{
  stdenv,
  mkDerivation,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  SDL2,
  qtdeclarative,
  libpulseaudio,
  glm,
  which,
}:

mkDerivation rec {
  pname = "projectm";
  version = "3.1.12";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "projectM";
    rev = "v${version}";
    sha256 = "sha256-oEfOx93JyR94II5NkUCvMwqxuV7ktpOHZ8PNMLCiqDw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    which
  ];

  buildInputs = [
    SDL2
    qtdeclarative
    libpulseaudio
    glm
  ];

  configureFlags = [
    "--enable-qt"
    "--enable-sdl"
  ];

  fixupPhase =
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      # NOTE: 2019-10-05: Upstream inserts the src path buring build into ELF rpath, so must delete it out
      # upstream report: https://github.com/projectM-visualizer/projectm/issues/245
      for entry in $out/bin/* ; do
        patchelf --set-rpath "$(patchelf --print-rpath $entry | tr ':' '\n' | grep -v 'src/libprojectM' | tr '\n' ':')" "$entry"
      done
    ''
    + ''
      wrapQtApp $out/bin/projectM-pulseaudio
      rm $out/bin/projectM-unittest
    '';

  meta = {
    homepage = "https://github.com/projectM-visualizer/projectm";
    description = "Cross-platform Milkdrop-compatible music visualizer";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
    longDescription = ''
      The open-source project that reimplements the esteemed Winamp Milkdrop by Geiss in a more modern, cross-platform reusable library.
      Read an audio input and produces mesmerizing visuals, detecting tempo, and rendering advanced equations into a limitless array of user-contributed visualizations.
    '';
  };
}
