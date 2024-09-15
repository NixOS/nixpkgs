{ lib
, stdenvNoCC
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "marwaita";
  version = "21";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    hash = "sha256-5igOzHfkW+HJtll2wLT5qWtLavoPCo170M8v4ID0Wf8=";
  };

  buildInputs = [
    gdk-pixbuf
    gtk_engines
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Marwaita* $out/share/themes
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "GTK theme supporting Budgie, Pantheon, Mate, Xfce4 and GNOME desktops";
    homepage = "https://www.pling.com/p/1239855/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
