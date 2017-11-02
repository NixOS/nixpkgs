{ stdenv, lib, fetchurl, patchelf, unzip }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "ipmicfg-${version}";
  version = "1.27.0";
  buildVersion = "170620";

  src = fetchurl {
    url = "ftp://ftp.supermicro.com/utility/IPMICFG/IPMICFG_${version}_build.${buildVersion}.zip";
    sha256 = "0mlhrxnkwazq5456csfds6w2z5pv2ksnqnxlv4prp07bwi2bccid";
  };

  buildInputs = [ unzip ];
  installPhase = ''
    mkdir -p "$out/opt/ipmicfg"
    cp Linux/64bit/* "$out/opt/ipmicfg"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) "$out/opt/ipmicfg/IPMICFG-Linux.x86_64"
    patchelf --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc ]}:${stdenv.cc.cc.lib}/lib64" "$out/opt/ipmicfg/IPMICFG-Linux.x86_64"

    mkdir "$out/bin"
    ln -s "$out/opt/ipmicfg/IPMICFG-Linux.x86_64" "$out/bin/ipmicfg"
  '';

   meta = with stdenv.lib; {
     license = licenses.unfree;
     maintainers = with maintainers; [ sorki ];
   };
}
