{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "ipmicfg-${version}";
  version = "1.27.0";
  buildVersion = "170620";

  src = fetchzip {
    url = "ftp://ftp.supermicro.com/utility/IPMICFG/IPMICFG_${version}_build.${buildVersion}.zip";
    sha256 = "0jr2vih4hzymb62mbqyykwcrjhbhazf6wr1g0cq8ji586i3z3vw5";
  };

  installPhase = ''
    mkdir -p "$out/bin" "$out/opt/ipmicfg"
    cp Linux/64bit/* "$out/opt/ipmicfg"

    patchelf "$out/opt/ipmicfg/IPMICFG-Linux.x86_64" \
       --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
       --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}"

    ln -s "$out/opt/ipmicfg/IPMICFG-Linux.x86_64" "$out/bin/ipmicfg"
  '';

   dontPatchShebangs = true; # There are no scripts and it complains about null bytes.

   meta = with stdenv.lib; {
     description = "Supermicro IPMI configuration tool";
     homepage = "http://www.supermicro.com/products/nfo/ipmi.cfm";
     license = licenses.unfree;
     platforms = [ "x86_64-linux" ];
     maintainers = with maintainers; [ sorki ];
   };
}
