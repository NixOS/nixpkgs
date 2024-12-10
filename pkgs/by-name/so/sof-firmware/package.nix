{ lib
, fetchurl
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "sof-firmware";
  version = "2024.09.2";

  src = fetchurl {
    url = "https://github.com/thesofproject/sof-bin/releases/download/v${version}/sof-bin-${version}.tar.gz";
    sha256 = "sha256-huaEGlXx1tHJFQOoSCwbR128rezbYVG/oKwAldHYpSo=";
  };

  dontFixup = true; # binaries must not be stripped or patchelfed

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/firmware/intel
    cp -av sof $out/lib/firmware/intel/sof
    cp -av sof-tplg $out/lib/firmware/intel/sof-tplg
    cp -av sof-ace-tplg $out/lib/firmware/intel/sof-ace-tplg
    cp -av sof-ipc4 $out/lib/firmware/intel/sof-ipc4
    cp -av sof-ipc4-tplg $out/lib/firmware/intel/sof-ipc4-tplg
    cp -av sof-ipc4-lib $out/lib/firmware/intel/sof-ipc4-lib
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/thesofproject/sof-bin/releases/tag/v${version}";
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc evenbrenden hmenke ];
    platforms = with platforms; linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
