{
  lib,
  stdenv,
  fetchFromGitHub,
  gdk-pixbuf,
  gtk-engine-murrine,
  gtk_engines,
  librsvg,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "marwaita-yellow";
  version = "20.3.1";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-yellow";
    rev = version;
    hash = "sha256-ClM2lvFFLNz+pF/pY7j/V5L24egB3oxpkH8cpZMSu5g=";
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
    description = "Marwaita GTK theme with Pop_os Linux style";
    homepage = "https://www.pling.com/p/1377894/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
