{ alsaLib, autoPatchelfHook, fetchurl, gtk3, libnotify
, makeDesktopItem, makeWrapper, nss, stdenv, udev, xdg_utils
, xorg
}:

with stdenv.lib;

let
  bits = "x86_64";

  version = "4.5.10";

  desktopItem = makeDesktopItem rec {
    name = "Wavebox";
    exec = "wavebox";
    icon = "wavebox";
    desktopName = name;
    genericName = name;
    categories = "Network;";
  };

  tarball = "Wavebox_${replaceStrings ["."] ["_"] (toString version)}_linux_${bits}.tar.gz";

in stdenv.mkDerivation rec {
  name = "wavebox-${version}";
  src = fetchurl {
    url = "https://github.com/wavebox/waveboxapp/releases/download/v${version}/${tarball}";
    sha256 = "0863x3gyzzbm6qs26j821b4iy596cc2h7ppdj6hq5rgr7c01ac9k";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = with xorg; [
    libXdmcp libXScrnSaver libXtst
  ] ++ [
    alsaLib gtk3 nss
  ];

  runtimeDependencies = [ udev.lib libnotify ];

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
      --prefix PATH : ${xdg_utils}/bin
  '';

  meta = with stdenv.lib; {
    description = "Wavebox messaging application";
    homepage = https://wavebox.io;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rawkode ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
