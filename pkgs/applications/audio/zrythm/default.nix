{ stdenv
, lib
, fetchFromGitHub
, fetchFromSourcehut
, SDL2
, alsa-lib
, appstream
, appstream-glib
, bash-completion
, boost
, breeze-icons
, carla
, chromaprint
, cmake
, curl
, dbus
, dconf
, faust2lv2
, fftw
, fftwFloat
, flex
, glib
, graphviz
, gtk4
, gtksourceview5
, guile
, help2man
, jq
, json-glib
, kissfft
, libadwaita
, libaudec
, libbacktrace
, libcyaml
, libepoxy
, libgtop
, libjack2
, libpanel
, libpulseaudio
, libsamplerate
, libsass
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
, sassc
, serd
, sord
, sox
, sratom
, texi2html
, vamp-plugin-sdk
, wrapGAppsHook
, xdg-utils
, xxHash
, zix
, zstd
}:

let
  # As of zrythm-1.0.0-beta.4.5.62, Zrythm needs clap
  # https://github.com/falktx/carla/tree/main/source/includes/clap, which is
  # only available on Carla unstable as of 2023-02-24.
  carla-unstable = carla.overrideAttrs (oldAttrs: rec {
    pname = "carla";
    version = "unstable-2023-02-24";

    src = fetchFromGitHub {
      owner = "falkTX";
      repo = pname;
      rev = "33a142f447925f55d00532933a1f28e9745c13eb";
      hash = "sha256-hQj0HlcOYfwsxG05pq/qcuKcOwDMV1ED+YdxBToBzvk=";
    };
  });
in stdenv.mkDerivation rec {
  pname = "zrythm";
  version = "1.0.0-beta.4.6.3";

  src = fetchFromSourcehut {
    owner = "~alextee";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5GBr8N+GzbptrvP/NisBXT0dsl9vn537B4InB00/N+A=";
  };

  nativeBuildInputs = [
    cmake
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
    sassc
    texi2html
    wrapGAppsHook
  ];

  buildInputs = [
    SDL2
    alsa-lib
    appstream
    appstream-glib
    bash-completion
    boost
    breeze-icons
    carla-unstable
    chromaprint
    curl
    dbus
    dconf
    faust2lv2
    fftw
    fftwFloat
    flex
    glib
    graphviz
    gtk4
    gtksourceview5
    guile
    json-glib
    kissfft
    libadwaita
    libbacktrace
    libcyaml
    libepoxy
    libgtop
    libjack2
    libpanel
    libpulseaudio
    libsamplerate
    libsass
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
    sox
    sratom
    vamp-plugin-sdk
    xdg-utils
    xxHash
    zix
    zstd
  ];

  # Zrythm uses meson to build, but requires cmake for dependency detection.
  dontUseCmakeConfigure = true;

  mesonFlags = [
    "-Db_lto=false"
    "-Dcarla=enabled"
    "-Dcarla_binaries_dir=${carla-unstable}/lib/carla"
    "-Ddebug=true"
    "-Dfftw3_threads_separate=false"
    "-Dfftw3_threads_separate_type=library"
    "-Dfftw3f_separate=false"
    "-Dlsp_dsp=disabled"
    "-Dmanpage=true"
    "-Drtaudio=enabled"
    "-Drtmidi=enabled"
    "-Dsdl=enabled"
    # "-Duser_manual=true" # needs sphinx-intl
  ];

  NIX_LDFLAGS = ''
    -lfftw3_threads -lfftw3f_threads
  '';

  GUILE_AUTO_COMPILE = 0;

  dontStrip = true;

  postPatch = ''
    substituteInPlace meson.build \
      --replace "'/usr/lib', '/usr/local/lib', '/opt/homebrew/lib'" "'${fftw}/lib'"

    chmod +x scripts/meson-post-install.sh
    patchShebangs ext/sh-manpage-completions/run.sh scripts/generic_guile_wrap.sh \
      scripts/meson-post-install.sh tools/check_have_unlimited_memlock.sh
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GSETTINGS_SCHEMA_DIR : "$out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas/"
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${breeze-icons}/share"
    )
  '';

  meta = with lib; {
    homepage = "https://www.zrythm.org";
    description = "Automated and intuitive digital audio workstation";
    maintainers = with maintainers; [ tshaynik magnetophon yuu ];
    platforms = platforms.linux;
    license = licenses.agpl3Plus;
  };
}
