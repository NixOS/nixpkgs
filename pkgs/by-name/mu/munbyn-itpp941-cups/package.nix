{
  stdenv,
  fetchurl,
  lib,
  autoPatchelfHook,
  cups,
}:

stdenv.mkDerivation {
  pname = "munbyn-itpp941-cups";
  # This was the first file packaged for NixOS, I'm not sure what the actual driver version is.
  version = "1.0.0";

  src = fetchurl {
    url = "https://filedn.com/lN6To1twXYMYeSDMQm2JQWV/ITPP941/01-Driver/Munbyn_Driver_Ubuntu_Install.run";
    hash = "sha256-qibdUgT0VOWnW7bMSriI89hrRYigjL+jTgr+2vp/6j0=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ cups ];

  unpackPhase = ''
    runHook preUnpack

    tail +9 $src > src.tar.gz
    tar zxf src.tar.gz

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cups/filter/Munbyn/Filter
    cp -rf Munbyn_Driver_Ubuntu/Munbyn/Filter/rastertolabel $out/lib/cups/filter/Munbyn/Filter

    mkdir -p $out/share/cups/model
    cp Munbyn_Driver_Ubuntu/Munbyn/PPDs/Munbyn_Label_Printer.ppd $out/share/cups/model

    runHook postInstall
  '';

  meta = with lib; {
    description = "CUPS Linux drivers for MUNBYN ITPP941 Label Printer (203 DPI version)";
    downloadPage = "https://munbyn.com/products/thermal-shipping-label-printer";
    homepage = "https://munbyn.com/products/thermal-shipping-label-printer";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ChocolateLoverRaj ];
    license = licenses.unfree;
  };
}
