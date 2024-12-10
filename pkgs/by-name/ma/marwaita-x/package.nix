{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  gdk-pixbuf,
  gtk-engine-murrine,
  gtk_engines,
  librsvg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "marwaita-x";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-x";
    rev = finalAttrs.version;
    sha256 = "sha256-uSJfrM1QOTTV03WS6BpQh3GCgkW4+9w3aw+giwiCYWU=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A new version for Marwaita GTK theme";
    homepage = "https://www.pling.com/p/2044790/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
  };
})
