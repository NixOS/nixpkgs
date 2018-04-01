{ stdenv, requireFile, lib
, openssl, qt56, xlibs, fontconfig, freetype, libpng12, zlib, glib }:

stdenv.mkDerivation rec {
  name = "packettracer-${version}";
  version = "7.1.1";

  src = requireFile {
    name = "Packet_Tracer_${version}_for_Linux_64_bit.tar";
    url = "http://www.netacad.com/about-networking-academy/packet-tracer";
    sha256 = "8ee064c92f2465fd79017397750f4d12c212c591d8feb1d198863e992613b3b7";
    message = ''
      This nix expression required that Packet_Tracer_${version}_for_Linux_64_bit.tar is already part of the store.
      Download it from http://www.netacad.com/about-networking-academy/packet-tracer and add it to the nix store with:

          nix-store --add-fixed sha256 Packet_Tracer_${version}_for_Linux_64_bit.tar

      This can't be done automatically because you need to create an account on
      their website and agree to their license terms before you can download it.
    '';
  };

  builder = ./builder.sh;

  libPath = stdenv.lib.makeLibraryPath [
    # Dependencies for bin/{PacketTracer7,linguist}
    stdenv.cc.cc
    openssl
    qt56.full

    # Dependencies for bin/meta
    xlibs.libX11
    xlibs.libXi
    xlibs.libxcb
    xlibs.xcbutilrenderutil
    xlibs.xcbutilimage
    xlibs.xcbutilwm
    xlibs.xcbutilkeysyms
    fontconfig
    freetype
    libpng12
    zlib
    # depends on libicui18n.so.52, replace with whatever icu59 has?
    # depends on libicuuc.so.52, but no lib for it is found
    glib
  ];

  meta = with stdenv.lib; {
    homepage = http://www.netacad.com/about-networking-academy/packet-tracer/;
    description = "Network simulation and visualization tool from Cisco";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.tmplt ];
  };

}
