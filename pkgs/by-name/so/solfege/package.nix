{
  lib,
  stdenv,
  alsa-utils,
  autoconf,
  automake,
  csound,
  docbook-xsl-ns,
  fetchurl,
  gdk-pixbuf,
  gettext,
  ghostscript,
  gnome-doc-utils,
  gobject-introspection,
  gtk3,
  librsvg,
  libxslt,
  lilypond,
  mpg123,
  pkg-config,
  python3Packages,
  swig,
  texinfo,
  timidity,
  txt2man,
  vorbis-tools,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "solfege";
  version = "3.23.4";
  pyproject = false;

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/solfege/solfege-${finalAttrs.version}.tar.gz";
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
    docbook-xsl-ns
    gdk-pixbuf
    gettext
    ghostscript
    gnome-doc-utils
    gobject-introspection
    libxslt
    lilypond
    pkg-config
    swig
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

  configureFlags = [
    "--enable-docbook-stylesheet=${docbook-xsl-ns}/share/xml/docbook-xsl-ns/html/chunk.xsl"
  ];

  # Csound is broken on Darwin; leave its command configurable at runtime there.
  preBuild = ''
    sed -i -e 's|wav_player=.*|wav_player=${
      if stdenv.hostPlatform.isDarwin then "/usr/bin/afplay" else "${alsa-utils}/bin/aplay"
    }|' \
           -e 's|midi_player=.*|midi_player=${timidity}/bin/timidity|' \
           -e 's|mp3_player=.*|mp3_player=${mpg123}/bin/mpg123|' \
           -e 's|ogg_player=.*|ogg_player=${vorbis-tools}/bin/ogg123|' \
           ${
             lib.optionalString (!stdenv.hostPlatform.isDarwin) "-e 's|csound=.*|csound=${csound}/bin/csound|'"
           } \
           -e 's|lilypond-book=.*|lilypond-book=${lilypond}/bin/lilypond-book|' \
           default.config
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Select native macOS audio instead of TiMidity's default JACK output.
    substituteInPlace default.config \
      --replace-fail 'midi_player_options=-idqq %s' 'midi_player_options=-Od -idqq %s'
  '';

  postBuild = ''
    make help/C/index.html
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Ear training program";
    homepage = "https://www.gnu.org/software/solfege/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      bjornfor
      anthonyroussel
    ];
    mainProgram = "solfege";
  };
})
