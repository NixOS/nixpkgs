{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "ipmicfg-${version}";
  version = "1.28.0";
  buildVersion = "180302";

  src = fetchzip {
    url = "ftp://ftp.supermicro.com/utility/IPMICFG/IPMICFG_${version}_build.${buildVersion}.zip";
    sha256 = "0hw853cwaaxmxy1sa3m7l9gqalwpbbvp4ghk8inr7dzwxjljmr02";
    extraPostFetch = "chmod u+rwX,go-rwx+X $out/";
  };

  installPhase = ''
    mkdir -p "$out/bin" "$out/opt/ipmicfg"
    cp Linux/64bit/* "$out/opt/ipmicfg"

    patchelf \
       --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
       --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}" \
       "$out/opt/ipmicfg/IPMICFG-Linux.x86_64"

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
