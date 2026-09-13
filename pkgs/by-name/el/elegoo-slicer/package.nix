{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "elegoo-slicer";
  version = "1.5.3.5";

  src = fetchurl {
    url = "https://github.com/elegooofficial/ElegooSlicer/releases/download/v${version}/ElegooSlicer_Linux_V${version}.AppImage";
    hash = "sha256-ezs/CODQ1Ru0cshYZdG+mwwoOFQj2rocsMOyJdAQGvw=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    pkgs.webkitgtk_4_1
    pkgs.libsoup_3
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/com.orcaslicer.ElegooSlicer.desktop \
      "$out/share/applications/com.orcaslicer.ElegooSlicer.desktop"

    install -Dm444 ${appimageContents}/ElegooSlicer.png \
      "$out/share/icons/hicolor/256x256/apps/ElegooSlicer.png"

    substituteInPlace "$out/share/applications/com.orcaslicer.ElegooSlicer.desktop" --replace-fail "Exec=AppRun %F" "Exec=$out/bin/elegoo-slicer %F" --replace-fail "X-KDE-RunOnDiscreteGpu=true" ""
  '';

  meta = {
    description = "Open-source slicer compatible with most FDM printers";
    homepage = "https://github.com/elegooofficial/ElegooSlicer";
    license = lib.licenses.agpl3Only;
    mainProgram = "elegoo-slicer";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ friendliness ];
  };
}
