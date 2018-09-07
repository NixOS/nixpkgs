{ stdenv, fetchurl, makeWrapper, makeDesktopItem
, atk, cairo, gdk_pixbuf, glib, gnome2, gtk2, libGLU_combined, pango, xorg
, lsb-release }:

let
  sha256 = {
    "x86_64-linux" = "0g19sac4j3m1nf400vn6qcww7prqg2p4k4zsj74i109kk1396aa2";
    "i686-linux"   = "1dd4ai2pclav9g872xil3x67bxy32gvz9pb3w76383pcsdh5zh45";
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
  version = "2.9.4";

  src = fetchurl {
    url = "https://download.anydesk.com/linux/${name}-${arch}.tar.gz";
    inherit sha256;
  };

  buildInputs = [
    atk cairo gdk_pixbuf glib gtk2 stdenv.cc.cc pango
    gnome2.gtkglext libGLU_combined
  ] ++ (with xorg; [
    libxcb libX11 libXdamage libXext libXfixes libXi libXmu
    libXrandr libXtst
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
