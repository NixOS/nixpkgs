{
  lib,
  stdenv,
  fetchurl,
  mfcj6510dwlpr,
  makeWrapper,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "mfcj6510dw-cupswrapper";
  version = "3.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006814/mfcj6510dw_cupswrapper_GPL_source_${version}.tar.gz";
    sha256 = "0y5iffybxjin8injrdmc9n9hl4s6b8n6ck76m1z78bzi88vwmhai";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    bash # shebang
  ];

  makeFlags = [
    "-C"
    "brcupsconfig"
    "all"
  ];

  installPhase = ''
    runHook preInstall

    TARGETFOLDER=$out/opt/brother/Printers/mfcj6510dw/cupswrapper
    mkdir -p $TARGETFOLDER
    cp PPD/brother_mfcj6510dw_printer_en.ppd $TARGETFOLDER
    cp brcupsconfig/brcupsconfpt1 $TARGETFOLDER
    cp scripts/cupswrappermfcj6510dw $TARGETFOLDER
    sed -i -e '26,304d' $TARGETFOLDER/cupswrappermfcj6510dw
    substituteInPlace $TARGETFOLDER/cupswrappermfcj6510dw \
      --replace-fail "\$ppd_file_name" "$TARGETFOLDER/brother_mfcj6510dw_printer_en.ppd"

    CPUSFILTERFOLDER=$out/lib/cups/filter
    mkdir -p $TARGETFOLDER $CPUSFILTERFOLDER
    ln -s ${mfcj6510dwlpr}/lib/cups/filter/brother_lpdwrapper_mfcj6510dw $out/lib/cups/filter/brother_lpdwrapper_mfcj6510dw
    ##TODO: Use the cups filter instead of the LPR one.
    #cp scripts/cupswrappermfcj6510dw $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj6510dw
    #sed -i -e '110,258!d' $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj6510dw
    #sed -i -e '33,40d' $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj6510dw
    #sed -i -e '34,35d' $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj6510dw
    #substituteInPlace $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj6510dw \
    #  --replace-fail "/opt/brother/$``{device_model``}/$``{printer_model``}/lpd/filter$``{printer_model``}" \
    #    "${mfcj6510dwlpr}/opt/brother/Printers/mfcj6510dw/lpd/filtermfcj6510dw" \
    #  --replace-fail "/opt/brother/Printers/$``{printer_model``}/inf/br$``{printer_model``}rc" \
    #    "${mfcj6510dwlpr}/opt/brother/Printers/mfcj6510dw/inf/brmfcj6510dwrc" \
    #  --replace-fail "/opt/brother/$``{device_model``}/$``{printer_model``}/cupswrapper/brcupsconfpt1" \
    #    "$out/opt/brother/Printers/mfcj6510dw/cupswrapper/brcupsconfpt1" \
    #  --replace-fail "/usr/share/cups/model/Brother/brother_" "$out/opt/brother/Printers/mfcj6510dw/cupswrapper/brother_"
    #substituteInPlace $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj6510dw \
    #  --replace-fail "$``{printer_model``}" "mfcj6510dw" \
    #  --replace-fail "$``{printer_name``}" "MFCJ6510DW"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother MFC-J6510DW CUPS wrapper driver";
    license = with licenses; gpl2Plus;
    platforms = with platforms; linux;
    downloadPage = "http://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj6510dw_all&os=128";
    maintainers = with maintainers; [ ramkromberg ];
  };
}
