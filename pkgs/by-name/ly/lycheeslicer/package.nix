{
  lib,
  fetchurl,
  libxshmfence,
  appimageTools,
}:
let
  pname = "lycheeslicer";
  version = "7.3.1";
  src = fetchurl {
    hash = "sha256-21ySVT2Un/WAWxvEAH5GfrumGbsSaeNVjaMsL9mYwsg=";
    url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}.AppImage";
  };
  appimageContents = appimageTools.extract {
    inherit pname src version;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: [ libxshmfence ];
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/lycheeslicer.desktop \
      $out/share/applications/lycheeslicer.desktop
    substituteInPlace $out/share/applications/lycheeslicer.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/lycheeslicer.png \
      $out/share/icons/hicolor/512x512/apps/lycheeslicer.png
    substituteInPlace $out/share/applications/lycheeslicer.desktop \
      --replace-fail 'Icon=lycheeslicer' "Icon=$out/share/icons/hicolor/512x512/apps/lycheeslicer.png"
  '';

  meta = {
    description = "Bring your 3D models to life easily with our all-in-one slicer.";
    longDescription = ''
      Turn your 3D ideas into reality quickly and effortlessly with Lychee. Forget complex interfaces - Lychee simplifies
      the printing process and makes 3D printing accessible to everyone by offering the most innovative and user-friendly solutions.
    '';
    license = lib.licenses.unfree;
    homepage = "https://www.mango3d.io/";
    downloadPage = "https://www.mango3d.io/download-lychee-slicer";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ShyAssassin ];
    platforms = lib.platforms.linux;
  };
}
