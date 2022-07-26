{ alsa-lib, autoPatchelfHook, fetchurl, gtk3, libnotify
, makeDesktopItem, makeWrapper, nss, lib, stdenv, udev, xdg-utils
, xorg
}:

with lib;

let
  bits = "x86_64";

  version = "4.11.3";

  desktopItem = makeDesktopItem rec {
    name = "Wavebox";
    exec = "wavebox";
    icon = "wavebox";
    desktopName = name;
    genericName = name;
    categories = [ "Network" ];
  };

  tarball = "Wavebox_${replaceStrings ["."] ["_"] (toString version)}_linux_${bits}.tar.gz";

in stdenv.mkDerivation {
  pname = "wavebox";
  inherit version;
  src = fetchurl {
    url = "https://github.com/wavebox/waveboxapp/releases/download/v${version}/${tarball}";
    sha256 = "0z04071lq9bfyrlg034fmvd4346swgfhxbmsnl12m7c2m2b9z784";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = with xorg; [
    libXdmcp libXScrnSaver libXtst
  ] ++ [
    alsa-lib gtk3 nss
  ];

  runtimeDependencies = [ (getLib udev) libnotify ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/wavebox
    cp -r * $out/opt/wavebox

    # provide desktop item and icon
    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s $out/opt/wavebox/Wavebox-linux-x64/wavebox_icon.png $out/share/pixmaps/wavebox.png
  '';

  postFixup = ''
    makeWrapper $out/opt/wavebox/Wavebox $out/bin/wavebox \
      --prefix PATH : ${xdg-utils}/bin
  '';

  meta = with lib; {
    description = "Wavebox messaging application";
    homepage = "https://wavebox.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ rawkode ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
