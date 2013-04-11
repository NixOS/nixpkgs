{ stdenv
, fetchurl
, libtool
, libXext
, libSM
, libICE
, libX11
, libXft
, libXau
, libXdmcp
, libXrender
, freetype
, fontconfig
, openssl
}:

let
  version = "1.94.407";

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
    freetype
    fontconfig
    openssl
  ];

  src = fetchurl {
    url = "http://downloads.hipchat.com/linux/arch/hipchat-${version}-i686.pkg.tar.xz";
    sha256 = "0kyjpa2ir066zqkvs1zmnx6kvl8v4jfl8h7bw110cgigwmiplk7k";
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
        patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $file || true
        patchelf --set-rpath ${rpath}:$out/lib $file || true
    done
  '';

  meta = {
    description = "HipChat Desktop Client";
    homepage = http://www.hipchat.com;
    license = stdenv.lib.licenses.proprietary;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
