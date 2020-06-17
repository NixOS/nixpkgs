{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "ipmicfg";
  version = "1.30.0";
  buildVersion = "190710";

  src = fetchzip {
    url = "https://www.supermicro.com/wftp/utility/IPMICFG/IPMICFG_${version}_build.${buildVersion}.zip";
    sha256 = "0srkzivxa4qlf3x9zdkri7xfq7kjj4fsmn978vzmzsvbxkqswd5a";
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
