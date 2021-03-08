{ autoPatchelfHook, electron_7, fetchurl, makeDesktopItem, makeWrapper, nodePackages, nss, lib, stdenv, xdg_utils, xorg }:

let
  electron = electron_7;
in
stdenv.mkDerivation rec {
  pname = "rambox-pro";
  version = "1.4.1";

  dontBuild = true;
  dontStrip = true;

  buildInputs = [ nss xorg.libXext xorg.libxkbfile xorg.libXScrnSaver ];
  nativeBuildInputs = [ autoPatchelfHook makeWrapper nodePackages.asar ];

  src = fetchurl {
    url = "https://github.com/ramboxapp/download/releases/download/v${version}/RamboxPro-${version}-linux-x64.tar.gz";
    sha256 = "1bd4fba3ac8c20fa557ebfb110f6503d36e6c3dba0401d1073529dcae2c2ec1e";
  };

  installPhase = ''
    mkdir -p $out/{bin,resources/dist/renderer/assets/images/app,share/applications,share/icons/hicolor/256x256/apps}

    asar e resources/app.asar $out/resources

    substituteInPlace "$out/resources/dist/electron/main.js" \
      --replace ",isHidden:" ",path:\"$out/bin/ramboxpro\",isHidden:"

    cp $desktopItem/share/applications/* $out/share/applications
    cp $out/resources/dist/electron/imgs/256x256.png $out/share/icons/hicolor/256x256/apps/ramboxpro.png
    cp $out/resources/dist/electron/imgs/256x256.png $out/resources/dist/renderer/assets/images/app/icon.png
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/ramboxpro \
      --add-flags "$out/resources --without-update" \
      --prefix PATH : ${xdg_utils}/bin
  '';

  desktopItem = makeDesktopItem {
    name = "rambox-pro";
    exec = "ramboxpro";
    icon = "ramboxpro";
    type = "Application";
    desktopName = "Rambox Pro";
    categories = "Network;";
  };

  meta = with lib; {
    description = "Messaging and emailing app that combines common web applications into one";
    homepage = "https://rambox.pro";
    license = licenses.unfree;
    maintainers = with maintainers; [ chrisaw ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
