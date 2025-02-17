{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "intel-npu-firmware";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-npu-driver";
    rev = "bd414f6905d587bf4dd49a8f74511b7a5fd6f226";
    sha256 = "ChiVnZ7SiiW5UIjYmvj9cf1bgS+GPHX279Q9DIA11og=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/intel/vpu
    cp -P firmware/bin/*.bin $out/lib/firmware/intel/vpu

    mkdir -p $out/share/doc/intel-npu-driver
    cp LICENSE.md $out/share/doc/intel-npu-driver/LICENSE

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/intel/linux-npu-driver";
    description = "Intel NPU (Neural Processing Unit) firmware";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = with maintainers; [ pseudocc ];
  };
}
