{ mkDerivation
, lib
, fetchFromGitHub

, autoreconfHook
, pkgconfig
, SDL2
, qtdeclarative
, libpulseaudio
, glm

, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "projectm";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "projectM";
    rev = "v${version}";
    sha256 = "0xxwjr8gb38rg73cyrdlnlzqyn10qdrn0fk5icd28q6mg3497gwb";
  };

  nativeBuildInputs = [
    pkgconfig
    autoreconfHook
  ];

  outputs = [ "bin" "dev" "out" ]; # NOTE: 2019-10-05: libprojectM in "lib" creates a cyclic dependency on the "out"

  buildInputs = [
    SDL2
    qtdeclarative
    libpulseaudio
    glm

    wrapQtAppsHook
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
  '';

  meta = {
    homepage = "https://github.com/projectM-visualizer/projectm";
    description = "Cross-platform Milkdrop-compatible music visualizer.";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    longDescription = ''
      The open-source project that reimplements the esteemed Winamp Milkdrop by Geiss in a more modern, cross-platform reusable library.
      Read an audio input and produces mesmerizing visuals, detecting tempo, and rendering advanced equations into a limitless array of user-contributed visualizations.
    '';
  };

}
