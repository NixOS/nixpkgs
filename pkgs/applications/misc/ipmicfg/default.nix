{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "ipmicfg";
  version = "1.34.2";
  buildVersion = "230224";

  src = fetchzip {
    url =
      "https://www.supermicro.com/wdl/utility/IPMICFG/IPMICFG_${version}_build.${buildVersion}.zip";
    sha256 = "1s924y6f0lvmd2m0na1nh0vyqf8qpp34wc6ndi8fwga4ynj66l63";
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

  # There are no scripts and it complains about null bytes.
  dontPatchShebangs = true;

  meta = with lib; {
    description = "Supermicro IPMI configuration tool";
    homepage = "http://www.supermicro.com/products/nfo/ipmi.cfm";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ sorki ];
  };
}
