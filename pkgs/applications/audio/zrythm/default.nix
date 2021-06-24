{ stdenv
, fetchFromGitHub
, SDL2
, alsaLib
, libaudec
, bash
, bash-completion
, carla
, chromaprint
, ffmpeg
, fftw
, fftwFloat
, git
, gtk3
, gtksourceview3
, guile
, help2man
, libcyaml
, libgtop
, libjack2
, libsamplerate
, libsndfile
, libxml2
, libyaml
, lilv
, meson
, ninja
, pandoc
, pcre
, pkg-config
, python3
, rtaudio
, rtmidi
, rubberband
, serd
, sord
, sratom
, texi2html
, wrapGAppsHook
, xdg_utils
}:

stdenv.mkDerivation rec {
  pname = "zrythm";
  version = "v1.0.0-alpha.18.2.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0ps5rvpb21ndi4ja487j478r80ha68id75xp30ck2wvcv8i18z9l";
  };

  nativeBuildInputs = [
    libaudec
    git
    gtk3
    help2man
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
    ffmpeg
    fftw
    fftwFloat
    gtksourceview3
    guile
    libcyaml
    libgtop
    libjack2
    libsamplerate
    libsndfile
    libyaml
    lilv
    pcre
    rtaudio
    rtmidi
    rubberband
    serd
    sord
    sratom
    xdg_utils
  ];

  mesonFlags = [
    "-Denable_ffmpeg=true"
    "-Denable_rtmidi=true"
    "-Denable_rtaudio=true"
    "-Denable_sdl=true"
    "-Dmanpage=true"
    "-Duser_manual=true"
  ];

  postPatch = ''
    chmod +x resources/gen_gtk_resources_xml_wrap.sh # patchShebangs only works on executable files
    patchShebangs resources/gen_gtk_resources_xml_wrap.sh
  '';

  preInstall = ''
    patchShebangs meson_post_install_wrap.sh # gets created during build.
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.zrythm.org";
    description = "highly automated and intuitive digital audio workstation";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.agpl3Plus;
  };
}
