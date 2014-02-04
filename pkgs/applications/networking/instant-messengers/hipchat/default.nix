{ stdenv, fetchurl, libtool, libXext, libSM, libICE, libX11, libXft, libXau, libXdmcp, libXrender
, libxcb, libXfixes, libXcomposite, libXi, dbus, freetype, fontconfig, openssl, zlib, mesa
, libxslt, libxml2
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux"; 

let
  version = "2.1.982";

  rpath = stdenv.lib.makeSearchPath "lib" [
    stdenv.glibc
    stdenv.gcc.gcc
    libtool
    libXext
    libSM
    libICE
    libX11
    libXft
    libXau
    libXdmcp
    libXrender
    libxcb
    libXfixes
    libXcomposite
    libXi
    dbus
    freetype
    fontconfig
    openssl
    zlib
    mesa
    libxslt
    libxml2
  ];

  src = 
    if stdenv.system == "i686-linux" then fetchurl {
      url = "http://downloads.hipchat.com/linux/arch/i686/hipchat-${version}-i686.pkg.tar.xz";
      sha256 = "1i60fkl5hdx2p2yfsx9w8qkzn6hl8fajvfls0r0gc2bqc9whg6vn";
    } else fetchurl {
      url = "http://downloads.hipchat.com/linux/arch/x86_64/hipchat-${version}-x86_64.pkg.tar.xz";
      sha256 = "12bn4la9z1grkbcnixjwhadgxa2g6qkd5x7r3l3vn1sdalgal4ks";
    };

in stdenv.mkDerivation {
  name = "hipchat-${version}";

  buildCommand = ''
    tar xf ${src}
    mkdir -p $out
    mv opt/HipChat/lib $out
    mv opt/HipChat/bin $out
    mv usr/share $out
    patchShebangs $out/bin
    for file in $(find $out/lib -type f); do
        patchelf --set-interpreter $(cat $NIX_GCC/nix-support/dynamic-linker) $file || true
        patchelf --set-rpath ${rpath}:${stdenv.lib.optionalString stdenv.is64bit "${stdenv.gcc.gcc}/lib64:"}$out/lib $file || true
    done
    substituteInPlace $out/share/applications/hipchat.desktop \
      --replace /opt/HipChat/bin $out/bin
  '';

  meta = {
    description = "HipChat Desktop Client";
    homepage = http://www.hipchat.com;
    license = stdenv.lib.licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
