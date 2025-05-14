{
  lib,
  stdenv,
  fetchzip,
  glib,
  zlib,
  libglvnd,
  python3,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  version = "3.5";
  pname = "sam-ba";

  src = fetchzip {
    url = "https://ww1.microchip.com/downloads/en/DeviceDoc/sam-ba_${version}-linux_x86_64.tar.gz";
    sha256 = "1k0nbgyc98z94nphm2q7s82b274clfnayf4a2kv93l5594rzdbp1";
  };

  buildInputs = [
    glib
    libglvnd
    zlib

    (python3.withPackages (ps: [ ps.pyserial ]))
  ];

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin/" \
             "$out/opt/sam-ba/"
    cp -a . "$out/opt/sam-ba/"
    ln -sr "$out/opt/sam-ba/sam-ba" "$out/bin/"
    ln -sr "$out/opt/sam-ba/multi_sam-ba.py" "$out/bin/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Programming tools for Atmel SAM3/7/9 ARM-based microcontrollers";
    longDescription = ''
      Atmel SAM-BA software provides an open set of tools for programming the
      Atmel SAM3, SAM7 and SAM9 ARM-based microcontrollers.
    '';
    # Alternatively: https://www.microchip.com/en-us/development-tool/SAM-BA-In-system-Programmer
    homepage = "http://www.at91.com/linux4sam/bin/view/Linux4SAM/SoftwareTools";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.bjornfor ];
  };
}
