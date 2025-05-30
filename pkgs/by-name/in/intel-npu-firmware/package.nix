{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:

stdenvNoCC.mkDerivation rec {
  pname = "intel-npu-firmware";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-npu-driver";
    rev = "v${version}";
    hash = "sha256-ChiVnZ7SiiW5UIjYmvj9cf1bgS+GPHX279Q9DIA11og=";
  };

  installPhase = ''
    mkdir -p $out/lib/firmware/intel/vpu
    cp -P firmware/bin/*.bin $out/lib/firmware/intel/vpu
  '';

  meta = {
    homepage = "https://github.com/intel/linux-npu-driver";
    description = "Intel NPU (Neural Processing Unit) firmware";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pseudocc ];
  };
}
