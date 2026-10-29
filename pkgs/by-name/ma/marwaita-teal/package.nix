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

stdenv.mkDerivation (finalAttrs: {
  pname = "marwaita-teal";
  version = "24";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-teal";
    rev = finalAttrs.version;
    hash = "sha256-63VJrmb0TcsXT1JM77+ZxN4kOZPBlqR2ANAhY041QCA=";
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

  meta = {
    description = "Manjaro Style of Marwaita GTK theme";
    homepage = "https://www.pling.com/p/1351213/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
})
