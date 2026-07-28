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
  pname = "marwaita-yellow";
  version = "23";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-yellow";
    rev = finalAttrs.version;
    hash = "sha256-1nGQvN6xacMoRyT7WkNC2lKX/QnXA7pCBz1kIo0aOwA=";
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
    description = "Marwaita GTK theme with Pop_os Linux style";
    homepage = "https://www.pling.com/p/1377894/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
})
