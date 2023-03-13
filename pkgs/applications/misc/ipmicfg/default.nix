{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "ipmicfg";
  version = "1.34.1";
  buildVersion = "221026";

  src = fetchzip {
    url = "https://www.supermicro.com/wftp/utility/IPMICFG/IPMICFG_${version}_build.${buildVersion}.zip";
    sha256 = "sha256-Kj5nXiG5YoQPrvhrPOLC4I7hXINu8EM3oQN5Z5YhZi4=";
  };

  installPhase = ''
    mkdir -p "$out/bin" "$out/opt/ipmicfg"
    cp Linux/64bit/* "$out/opt/ipmicfg"

    patchelf \
       --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
       --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc ]}" \
       "$out/opt/ipmicfg/IPMICFG-Linux.x86_64"

    ln -s "$out/opt/ipmicfg/IPMICFG-Linux.x86_64" "$out/bin/ipmicfg"
  '';

   dontPatchShebangs = true; # There are no scripts and it complains about null bytes.

   meta = with lib; {
     description = "Supermicro IPMI configuration tool";
     homepage = "http://www.supermicro.com/products/nfo/ipmi.cfm";
     sourceProvenance = with sourceTypes; [ binaryNativeCode ];
     license = licenses.unfree;
     platforms = [ "x86_64-linux" ];
     maintainers = with maintainers; [ sorki ];
   };
}
