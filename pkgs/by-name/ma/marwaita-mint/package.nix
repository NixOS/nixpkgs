{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "marwaita-mint";
  version = "20.3.1";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-mint";
    rev = finalAttrs.version;
    hash = "sha256-0IgQbBragalLO0zVU36ZWxF3Q47cfEQ15HxQ2j9QhIc=";
  };

  buildInputs = [
    gdk-pixbuf
    gtk_engines
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Marwaita* $out/share/themes
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Variation for marwaita GTK theme based on linux mint color scheme";
    homepage = "https://www.pling.com/p/1674243";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
  };
})
