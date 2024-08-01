{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "redbean";
  version = "2.2";

  src = fetchurl {
    url = "https://redbean.dev/redbean-${version}.com";
    hash = "sha256-24/HzFp3A7fMuDCjZutp5yj8eJL9PswJPAidg3qluRs=";
  };

  dontUnpack = true;

  dontBuild = true;

  dontFixup = true; # essential, otherwise cosmopolitcan libc exec-header gets corrupted

  installPhase = ''
    install -D $src $out/bin/redbean.com
  '';

  meta = with lib; {
    description = "A single-file distributable web server";
    license = "free"; # https://github.com/jart/cosmopolitan/blob/master/LICENSE + indirectly uses MIT, BSD-2, BSD-3, zlib
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "https://redbean.dev";
    maintainers = with maintainers; [ coderofsalvation ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-windows" "i686-windows" "x86_64-darwin" ];
  };
}

