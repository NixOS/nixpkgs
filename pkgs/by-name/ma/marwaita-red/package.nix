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
  pname = "marwaita-red";
  version = "22.2";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    hash = "sha256-MxGjJLPjvLc1kPDc9ib6hIxgbMrF8Cm+HCm2CGSrf+s=";
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
    description = "Marwaita GTK theme with Peppermint Os Linux style";
    homepage = "https://www.pling.com/p/1399569/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
