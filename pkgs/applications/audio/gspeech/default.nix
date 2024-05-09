{ lib
, fetchFromGitHub
, python3
, gtk3
, wrapGAppsHook3
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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = pname;
    rev = version;
    sha256 = "0z11yxvgi8m2xjmmf56zla91jpmf0a4imwi9qqz6bp51pw4sk8gp";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
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

  postInstall = ''
    install -Dm444 gspeech.desktop -t $out/share/applications
    install -Dm444 icons/*.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  postFixup = ''
    wrapProgram $out/bin/gspeech --prefix PATH : ${lib.makeBinPath [ picotts sox ]}
    wrapProgram $out/bin/gspeech-cli --prefix PATH : ${lib.makeBinPath [ picotts sox ]}
  '';

  strictDeps = false;

  meta = with lib; {
    description = "A minimal GUI for the Text To Speech 'Svox Pico'. Read clipboard or selected text in different languages and manage it : pause, stop, replay";
    homepage = "https://github.com/mothsART/gSpeech";
    maintainers = with maintainers; [ mothsart ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}

