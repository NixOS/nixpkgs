{ stdenv, fetchurl, makeWrapper, makeDesktopItem
, atk, cairo, gdk-pixbuf, glib, gnome2, gtk2, libGLU_combined, pango, xorg
, lsb-release, freetype, fontconfig, pangox_compat, polkit, polkit_gnome
, pulseaudio }:

let
  sha256 = {
    x86_64-linux = "1zdbgbbdavaqx4y02sw9y7i1r9wkxqccrqkn0sp5847a26cpk9k9";
    i386-linux   = "11qwyxvy3c3n7hvksmlsfl9vvqaqkv3kwbk5rgjyy7vy8vn4kjmk";
  }.${stdenv.hostPlatform.system} or (throw "system ${stdenv.hostPlatform.system} not supported");

  arch = {
    x86_64-linux = "amd64";
    i386-linux   = "i386";
  }.${stdenv.hostPlatform.system} or (throw "system ${stdenv.hostPlatform.system} not supported");

  description = "Desktop sharing application, providing remote support and online meetings";

  desktopItem = makeDesktopItem {
    name = "AnyDesk";
    exec = "@out@/bin/anydesk";
    icon = "anydesk";
    desktopName = "AnyDesk";
    genericName = description;
    categories = "Application;Network;";
    startupNotify = "false";
  };

in stdenv.mkDerivation rec {
  pname = "anydesk";
  version = "5.4.1";

  src = fetchurl {
    url = "https://download.anydesk.com/linux/${pname}-${version}-${arch}.tar.gz";
    inherit sha256;
  };

  buildInputs = [
    atk cairo gdk-pixbuf glib gtk2 stdenv.cc.cc pango
    gnome2.gtkglext libGLU_combined freetype fontconfig
    pangox_compat polkit polkit_gnome pulseaudio
  ] ++ (with xorg; [
    libxcb libxkbfile libX11 libXdamage libXext libXfixes libXi libXmu
    libXrandr libXtst libXt libICE libSM libXrender
  ]);

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{applications,doc/anydesk,icons/hicolor}
    install -m755 anydesk $out/bin/anydesk
    cp copyright README $out/share/doc/anydesk
    cp -r icons/hicolor/* $out/share/icons/hicolor/
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
    homepage = https://www.anydesk.com;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ shyim ];
  };
}
