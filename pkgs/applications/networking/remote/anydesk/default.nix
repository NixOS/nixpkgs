{ stdenv, fetchurl, makeWrapper
, cairo, gdk_pixbuf, glib, gnome2, gtk2, pango, xorg
, lsb-release }:

let
  sha256 = {
    "x86_64-linux" = "0g19sac4j3m1nf400vn6qcww7prqg2p4k4zsj74i109kk1396aa2";
    "i686-linux"   = "1dd4ai2pclav9g872xil3x67bxy32gvz9pb3w76383pcsdh5zh45";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  arch = {
    "x86_64-linux" = "amd64";
    "i686-linux"   = "i686";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

in stdenv.mkDerivation rec {
  name = "anydesk-${version}";
  version = "2.9.4";

  src = fetchurl {
    url = "https://download.anydesk.com/linux/${name}-${arch}.tar.gz";
    inherit sha256;
  };

  libPath = stdenv.lib.makeLibraryPath ([
    cairo gdk_pixbuf glib gtk2 stdenv.cc.cc pango
    gnome2.gtkglext
  ] ++ (with xorg; [
    libxcb libX11 libXdamage libXext libXfixes libXi
    libXrandr libXtst
  ]));

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/icons/hicolor,share/doc/anydesk}
    install -m755 anydesk $out/bin/anydesk
    cp changelog copyright README $out/share/doc/anydesk
    cp -r icons/* $out/share/icons/hicolor/
  '';

  postFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "${libPath}" \
      $out/bin/anydesk

    wrapProgram $out/bin/anydesk \
      --prefix PATH : ${stdenv.lib.makeBinPath [ lsb-release ]}
  '';

  meta = with stdenv.lib; {
    description = "Desktop sharing application, providing remote support and online meetings";
    homepage = http://www.anydesk.com;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
