{ mkDerivation
, lib
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, SDL2
, qtdeclarative
, libpulseaudio
, glm
, which
}:

mkDerivation rec {
  pname = "projectm";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "projectM";
    rev = "v${version}";
    sha256 = "1wm5fym6c1yb972pmil7j9axinqqwrj68cwd2sc7ky8c5z2fsdna";
  };

  nativeBuildInputs = [
    pkgconfig
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

  fixupPhase = ''
    # NOTE: 2019-10-05: Upstream inserts the src path buring build into ELF rpath, so must delete it out
    # upstream report: https://github.com/projectM-visualizer/projectm/issues/245
    for entry in $out/bin/* ; do
      patchelf --set-rpath "$(patchelf --print-rpath $entry | tr ':' '\n' | grep -v 'src/libprojectM' | tr '\n' ':')" "$entry"
    done
    wrapQtApp $out/bin/projectM-pulseaudio
    rm $out/bin/projectM-unittest
  '';

  meta = {
    homepage = "https://github.com/projectM-visualizer/projectm";
    description = "Cross-platform Milkdrop-compatible music visualizer";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ajs124 ];
    longDescription = ''
      The open-source project that reimplements the esteemed Winamp Milkdrop by Geiss in a more modern, cross-platform reusable library.
      Read an audio input and produces mesmerizing visuals, detecting tempo, and rendering advanced equations into a limitless array of user-contributed visualizations.
    '';
  };
}
