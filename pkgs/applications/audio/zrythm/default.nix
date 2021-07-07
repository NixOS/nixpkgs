{ stdenv
, lib
, fetchFromGitHub
, SDL2
, alsaLib
, libaudec
, bash
, bash-completion
, breeze-icons
, carla
, chromaprint
, epoxy
, ffmpeg
, fftw
, fftwFloat
, flex
, git
, glib
, gtk3
, gtksourceview3
, gtksourceview4
, guile
, graphviz
, help2man
, libbacktrace
, libcyaml
, libgtop
, libjack2
, libsamplerate
, libsndfile
, libxml2
, libyaml
, lilv
, lv2
, meson
, ninja
, pandoc
, pcre
, pcre2
, pkg-config
, python3
, reproc
, rtaudio
, rtmidi
, rubberband
, serd
, sord
, sratom
, texi2html
, wrapGAppsHook
, xdg_utils
, xxHash
, zstd
}:

stdenv.mkDerivation rec {
  pname = "zrythm";
  version = "1.0.0-alpha.19.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wNkciSDOb82zlHDUck+mN6WSzbAFP6XJDExbbuZ+E94=";
  };

  nativeBuildInputs = [
    git
    gtk3
    help2man
    libaudec
    libxml2
    meson
    ninja
    pandoc
    pkg-config
    python3
    python3.pkgs.sphinx
    texi2html
    wrapGAppsHook
  ];

  buildInputs = [
    SDL2
    alsaLib
    bash-completion
    carla
    chromaprint
    epoxy
    ffmpeg
    fftw
    fftwFloat
    flex
    breeze-icons
    glib
    gtksourceview3
    gtksourceview4
    graphviz
    guile
    libbacktrace
    libcyaml
    libgtop
    libjack2
    libsamplerate
    libsndfile
    libyaml
    lilv
    lv2
    pcre
    pcre2
    reproc
    rtaudio
    rtmidi
    rubberband
    serd
    sord
    sratom
    xdg_utils
    xxHash
    zstd
  ];

  mesonFlags = [
    "-Denable_ffmpeg=true"
    "-Denable_rtmidi=true"
    "-Denable_rtaudio=true"
    "-Denable_sdl=true"
    "-Dmanpage=true"
    # "-Duser_manual=true" # needs sphinx-intl
    "-Dlsp_dsp=disabled"
  ];

  NIX_LDFLAGS = ''
    -lfftw3_threads -lfftw3f_threads
  '';

  postPatch = ''
    chmod +x scripts/meson-post-install.sh
    patchShebangs ext/sh-manpage-completions/run.sh scripts/generic_guile_wrap.sh \
      scripts/meson-post-install.sh tools/check_have_unlimited_memlock.sh
  '';

  meta = with lib; {
    homepage = "https://www.zrythm.org";
    description = "highly automated and intuitive digital audio workstation";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.agpl3Plus;
  };
}
