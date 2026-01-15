{
  lib,
  python3Packages,
  fetchFromGitHub,
  gtk4,
  wrapGAppsHook3,
  gst_all_1,
  gobject-introspection,
  adwaita-icon-theme,
}:

python3Packages.buildPythonApplication {
  pname = "gscrabble";
  version = "1.6";
  format = "other";

  src = fetchFromGitHub {
    owner = "ThierryHFR";
    repo = "gscrabble";
    tag = "1.6+ordissimo1";
    hash = "sha256-4xFwpmWFamMUbzesp0wLTw/jh4h201wI/a7TWqfao+k=";
  };

  doCheck = false;

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-bad
    adwaita-icon-theme
    gtk4
  ];

  dependencies = [
    python3Packages.gst-python
    python3Packages.pygobject3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/GScrabble
    cp -r * $out/share/GScrabble/

    mkdir -p $out/bin
    install -m755 gscrabble $out/bin/gscrabble

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/share/GScrabble/modules"
      )
  '';

  meta = {
    description = "Golden Scrabble crossword puzzle game";
    homepage = "https://github.com/ThierryHFR/gscrabble/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
  };
}
