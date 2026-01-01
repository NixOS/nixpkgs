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
  version = "24";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-red";
    rev = version;
    hash = "sha256-21U3Z53v2PDJ7Io9WZypQiZPM4mjTa3z6W+vE9qNouA=";
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

<<<<<<< HEAD
  meta = {
    description = "Marwaita GTK theme with Peppermint Os Linux style";
    homepage = "https://www.pling.com/p/1399569/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
=======
  meta = with lib; {
    description = "Marwaita GTK theme with Peppermint Os Linux style";
    homepage = "https://www.pling.com/p/1399569/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
