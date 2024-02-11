{ stdenv
, lib
, fetchFromGitHub
, fetchFromGitLab
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
, soxr
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
  # Error: Dependency carla-host-plugin found: NO found 2.5.6 but need: '>=2.6.0'
  # So we need Carla unstable
  carla-unstable = carla.overrideAttrs (oldAttrs: rec {
    pname = "carla";
    version = "unstable-2023-08-27";

    src = fetchFromGitHub {
      owner = "falkTX";
      repo = pname;
      rev = "be784fcbe29f9f7eb52298023dcbdb11c0b8604a";
      hash = "sha256-3TIXGvZpfZD4AmsRIEDd3BpeMusL9NTSVtPfs3ng6eY=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "zrythm";
  version = "1.0.0-beta.4.12.5";

  src = fetchFromGitLab {
    domain = "gitlab.zrythm.org";
    owner = "zrythm";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ldj9qQxHewM3ecbf9AQ8VUkreJdi6MCv7KwrT2xpqKc=";
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
    soxr
    sratom
    vamp-plugin-sdk
    xdg-utils
    xxHash
    zix
    zstd
  ];

  # Zrythm uses meson to build, but requires cmake for dependency detection.
  dontUseCmakeConfigure = true;

  dontWrapQtApps = true;

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
