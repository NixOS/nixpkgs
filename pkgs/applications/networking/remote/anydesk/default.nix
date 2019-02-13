{ stdenv, fetchurl, makeWrapper, makeDesktopItem
, atk, cairo, gdk_pixbuf, glib, gnome2, gtk2, libGLU_combined, pango, xorg
, lsb-release, freetype, fontconfig, pangox_compat, polkit, polkit_gnome }:

let
  sha256 = {
    "x86_64-linux" = "08kdxsg9npb1nmlr2jyq7p238735kqkp7c5xckxn6rc4cp12n2y2";
    "i686-linux"   = "11r5d4234zbkkgyrd7q9x3w7s7lailnq7z4x8cnhpr8vipzrg7h2";
  }."${stdenv.hostPlatform.system}" or (throw "system ${stdenv.hostPlatform.system} not supported");

  arch = {
    "x86_64-linux" = "amd64";
    "i686-linux"   = "i686";
  }."${stdenv.hostPlatform.system}" or (throw "system ${stdenv.hostPlatform.system} not supported");

  description = "Desktop sharing application, providing remote support and online meetings";

  desktopItem = makeDesktopItem rec {
    name = "anydesk";
    exec = "@out@/bin/anydesk";
    icon = "anydesk";
    desktopName = "anydesk";
    genericName = description;
    categories = "Application;Network;";
    startupNotify = "false";
  };

in stdenv.mkDerivation rec {
  name = "anydesk-${version}";
  version = "4.0.1";

  src = fetchurl {
    url = "https://download.anydesk.com/linux/${name}-${arch}.tar.gz";
    inherit sha256;
  };

  buildInputs = [
    atk cairo gdk_pixbuf glib gtk2 stdenv.cc.cc pango
    gnome2.gtkglext libGLU_combined freetype fontconfig
    pangox_compat polkit polkit_gnome
  ] ++ (with xorg; [
    libxcb libX11 libXdamage libXext libXfixes libXi libXmu
    libXrandr libXtst libXt libICE libSM
  ]);

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{applications,doc/anydesk,icons/hicolor}
    install -m755 anydesk $out/bin/anydesk
    cp changelog copyright README $out/share/doc/anydesk
    cp -r icons/* $out/share/icons/hicolor/
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications

    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "${stdenv.lib.makeLibraryPath buildInputs}" \
      $out/bin/anydesk

    wrapProgram $out/bin/anydesk \
      --prefix PATH : ${stdenv.lib.makeBinPath [ lsb-release ]}

    substituteInPlace $out/share/applications/*.desktop \
      --subst-var out
  '';

  meta = with stdenv.lib; {
    inherit description;
    homepage = http://www.anydesk.com;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
