{
  lib,
  stdenvNoCC,
  intel-npu-driver,
  ...
}:

stdenvNoCC.mkDerivation {
  inherit (intel-npu-driver) version src;
  pname = "intel-npu-firmware";

  installPhase = ''
    mkdir -p $out/lib/firmware/intel/vpu
    cp -P firmware/bin/*.bin $out/lib/firmware/intel/vpu
  '';

  meta = {
    inherit (intel-npu-driver.meta)
      homepage
      platforms
      license
      maintainers
      ;
    description = "Intel NPU (Neural Processing Unit) firmware";
  };
}
