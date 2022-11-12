{ alsa-lib, autoPatchelfHook, fetchurl, gtk3, libnotify
, makeDesktopItem, makeWrapper, nss, lib, stdenv, udev, xdg-utils
, xorg, qtbase, wrapQtAppsHook, mesa
}:

let
  bits = "x86_64";

  version = "10.107.10";

  desktopItem = makeDesktopItem rec {
    name = "Wavebox";
    exec = "wavebox";
    icon = "wavebox";
    desktopName = name;
    genericName = name;
    categories = [ "Network" ];
  };

  tarball = "Wavebox_${version}-2.tar.gz";

in stdenv.mkDerivation {
  pname = "wavebox";
  inherit version;
  src = fetchurl {
    url = "https://download.wavebox.app/stable/linux/tar/${tarball}";
    sha256 = "17q72bmq461bh75dwawwfpc7pd73pahx6gm6rd89kb5xgad01dvi";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper wrapQtAppsHook ];

  buildInputs = with xorg; [
    libXdmcp libXScrnSaver libXtst libXdamage libXrandr
  ] ++ [
    alsa-lib qtbase nss stdenv.cc.cc.lib gtk3 mesa
  ];

  runtimeDependencies = [ (lib.getLib udev) libnotify ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/wavebox
    cp -r * $out/opt/wavebox

    # provide desktop item and icon
    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s $out/opt/wavebox/Wavebox-linux-x64/wavebox_icon.png $out/share/pixmaps/wavebox.png
  '';

  postFixup = ''
    # make xdg-open overrideable at runtime
    makeWrapper $out/opt/wavebox/wavebox $out/bin/wavebox \
      --suffix PATH : ${xdg-utils}/bin
  '';

  meta = with lib; {
    description = "Browser application for webapps";
    homepage = https://wavebox.io;
    changelog = https://wavebox.io/blog/tag/releases/;
    license = licenses.unfree;
    maintainers = with maintainers; [ rawkode eddsteel ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
