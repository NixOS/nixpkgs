{ lib
, fetchFromGitHub
, python3
, gtk3
, wrapGAppsHook
, glibcLocales
, gobject-introspection
, gettext
, pango
, gdk-pixbuf
, librsvg
, atk
, libnotify
, libappindicator-gtk3
, gst_all_1
, makeWrapper
, picotts
, sox
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gSpeech";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = pname;
    rev = version;
    sha256 = "11pvdpb9jjssp8nmlj21gs7ncgfm89kw26mfc8c2x8w2q4h92ja3";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
    pango
    gdk-pixbuf
    atk
    gettext
    libnotify
    libappindicator-gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    makeWrapper
  ];

  buildInputs = [
    glibcLocales
    gtk3
    python3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    librsvg
  ];

  postFixup = ''
    wrapProgram $out/bin/gspeech --prefix PATH : ${lib.makeBinPath [ picotts ]}
    wrapProgram $out/bin/gspeech-cli --prefix PATH : ${lib.makeBinPath [ picotts ]}
  '';

  strictDeps = false;

  meta = with lib; {
    description = "A minimal GUI for the Text To Speech 'Svox Pico'. Read clipboard or selected text in different languages and manage it : pause, stop, replay.";
    homepage = "https://github.com/mothsART/gSpeech";
    maintainers = with maintainers; [ mothsart ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}

