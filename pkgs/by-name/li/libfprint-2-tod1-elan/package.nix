{
  stdenvNoCC,
  lib,
  fetchzip,
  libfprint-tod,
  openssl,
  gusb,
  glib,
  autoPatchelfHook,
}:

stdenvNoCC.mkDerivation {
  pname = "libfprint-2-tod1-elan";
  version = "0.0.8";

  src = fetchzip {
    url = "https://download.lenovo.com/pccbbs/mobiles/r1slf01w.zip";
    hash = "sha256-GD/BebPto1fFLgyvpiitt+ngwEtdsnKsvdFNeSmVDmw=";
    # .so is in a subzip
    postFetch = ''
      unpackFile $out/*
      rm $out/*.zip
      mv * $out/
    '';
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libfprint-tod
    openssl
    gusb
    glib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 libfprint-2-tod1-elan.so -t "$out/lib/libfprint-2/tod-1/"

    runHook postInstall
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "Elan(04f3:0c4b) driver module for libfprint-2-tod Touch OEM Driver";
    homepage = "https://support.lenovo.com/us/en/downloads/ds560939-elan-fingerprint-driver-for-ubuntu-2204-thinkpad-e14-gen-4-e15-gen-4";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ qdlmcfresh ];
  };
}
