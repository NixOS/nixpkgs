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
  version = "20.2-unstable-2024-07-01";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-mint";
    rev = "ecdb79b45937466b7d8377d294838da3e8f4e61a";
    hash = "sha256-57oZgacQQF6nZney0AxSbGfv45eeBLjXHBK6wp1251U=";
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
