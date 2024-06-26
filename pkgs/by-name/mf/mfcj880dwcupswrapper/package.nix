{
  lib,
  stdenv,
  fetchurl,
  mfcj880dwlpr,
  makeWrapper,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "mfcj880dw-cupswrapper";
  version = "1.0.0-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf102044/mfcj880dw_cupswrapper_GPL_source_${version}.tar.gz";
    sha256 = "bf291fe31d64afeaefb5b0e606f4baf80c41d80009e34b32b77d56f759e9cf94";
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

    TARGETFOLDER=$out/opt/brother/Printers/mfcj880dw/cupswrapper
    mkdir -p $TARGETFOLDER
    cp PPD/brother_mfcj880dw_printer_en.ppd $TARGETFOLDER
    cp brcupsconfig/brcupsconfpt1 $TARGETFOLDER
    cp cupswrapper/cupswrappermfcj880dw $TARGETFOLDER
    sed -i -e '26,306d' $TARGETFOLDER/cupswrappermfcj880dw
    substituteInPlace $TARGETFOLDER/cupswrappermfcj880dw \
      --replace-fail "\$ppd_file_name" "$TARGETFOLDER/brother_mfcj880dw_printer_en.ppd"

    CPUSFILTERFOLDER=$out/lib/cups/filter
    mkdir -p $TARGETFOLDER $CPUSFILTERFOLDER
    ln -s ${mfcj880dwlpr}/lib/cups/filter/brother_lpdwrapper_mfcj880dw $out/lib/cups/filter/brother_lpdwrapper_mfcj880dw

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother MFC-J880DW CUPS wrapper driver";
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj880dw_us_eu_as&os=128";
    maintainers = with maintainers; [ _6543 ];
  };
}
