{
  lib,
  alsa-utils,
  autoconf,
  automake,
  csound,
  fetchurl,
  gdk-pixbuf,
  gettext,
  gobject-introspection,
  gtk3,
  librsvg,
  lilypond,
  mpg123,
  pkg-config,
  python3Packages,
  texinfo,
  timidity,
  txt2man,
  vorbis-tools,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "solfege";
  version = "3.23.4";
  format = "other";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/solfege/solfege-${version}.tar.gz";
    hash = "sha256-t6JJxgGk5hpN76o9snxtM07tkYnwpQ808M/8Ttw+gWk=";
  };

  patches = [
    ./css.patch
    ./menubar.patch
    ./texinfo.patch
    ./webbrowser.patch
  ];

  preConfigure = ''
    aclocal
    autoconf
  '';

  nativeBuildInputs = [
    autoconf
    automake
    gdk-pixbuf
    gettext
    gobject-introspection
    pkg-config
    texinfo
    txt2man
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    librsvg
  ];

  propagatedBuildInputs = with python3Packages; [
    pycairo
    pygobject3
  ];

  preBuild = ''
    sed -i -e 's|wav_player=.*|wav_player=${alsa-utils}/bin/aplay|' \
           -e 's|midi_player=.*|midi_player=${timidity}/bin/timidity|' \
           -e 's|mp3_player=.*|mp3_player=${mpg123}/bin/mpg123|' \
           -e 's|ogg_player=.*|ogg_player=${vorbis-tools}/bin/ogg123|' \
           -e 's|csound=.*|csound=${csound}/bin/csound|' \
           -e 's|lilypond-book=.*|lilypond-book=${lilypond}/bin/lilypond-book|' \
           default.config
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Ear training program";
    homepage = "https://www.gnu.org/software/solfege/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      bjornfor
      orivej
      anthonyroussel
    ];
    mainProgram = "solfege";
  };
}
