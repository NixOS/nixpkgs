{ stdenv
, lib
, fetchFromGitHub
, SDL2
, alsa-lib
, libaudec
, bash-completion
, breeze-icons
, carla
, chromaprint
, cmake
, curl
, dconf
, libepoxy
, fftw
, fftwFloat
, flex
, glib
, gtk4
, gtksourceview5
, guile
, graphviz
, help2man
, json-glib
, jq
, libbacktrace
, libcyaml
, libgtop
, libjack2
, libpulseaudio
, libsamplerate
, libsndfile
, libsoundio
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
, xdg-utils
, xxHash
, vamp-plugin-sdk
, zstd
, libadwaita
, sassc
}:

stdenv.mkDerivation rec {
  pname = "zrythm";
  version = "1.0.0-alpha.28.1.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ERE7I6E3+RmmpnZEtcJL/1v9a37IwFauVsbJvI9gsRQ=";
  };

  nativeBuildInputs = [
    help2man
    jq
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
    cmake
  ];

  buildInputs = [
    SDL2
    alsa-lib
    bash-completion
    carla
    chromaprint
    curl
    dconf
    libepoxy
    fftw
    fftwFloat
    flex
    breeze-icons
    glib
    gtk4
    gtksourceview5
    graphviz
    guile
    json-glib
    libbacktrace
    libcyaml
    libgtop
    libjack2
    libpulseaudio
    libsamplerate
    libsndfile
    libsoundio
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
    vamp-plugin-sdk
    xdg-utils
    xxHash
    zstd
    libadwaita
    sassc
  ];

  mesonFlags = [
    "-Drtmidi=enabled"
    "-Drtaudio=enabled"
    "-Dsdl=enabled"
    "-Dcarla=enabled"
    "-Dmanpage=true"
    # "-Duser_manual=true" # needs sphinx-intl
    "-Dlsp_dsp=disabled"
    "-Db_lto=false"
    "-Ddebug=true"
  ];

  NIX_LDFLAGS = ''
    -lfftw3_threads -lfftw3f_threads
  '';

  dontStrip = true;

  postPatch = ''
    chmod +x scripts/meson-post-install.sh
    patchShebangs ext/sh-manpage-completions/run.sh scripts/generic_guile_wrap.sh \
      scripts/meson-post-install.sh tools/check_have_unlimited_memlock.sh
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GSETTINGS_SCHEMA_DIR : "$out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas/"
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
             )
  '';

  meta = with lib; {
    homepage = "https://www.zrythm.org";
    description = "Highly automated and intuitive digital audio workstation";
    maintainers = with maintainers; [ tshaynik magnetophon ];
    platforms = platforms.linux;
    license = licenses.agpl3Plus;
  };
}
