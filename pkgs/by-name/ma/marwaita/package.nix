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
  version = "20.2-unstable-2024-07-01";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = "da6614b0fcb14d83de94f9b23b75baec03b3bc68";
    hash = "sha256-XP3mDa8KOyqd4ECnjvmfk84lU56qBYPGZAT9/fEp6N8=";
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
