{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  coreutils,
  gnugrep,
  gnused,
  mfc465cnlpr,
  pkgsi686Linux,
  psutils,
}:

stdenv.mkDerivation rec {
  pname = "mfc465cncupswrapper";
  version = "1.0.1-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006134/${pname}-${version}.i386.deb";
    sha256 = "59a62ed3cf10f1565c08ace55832bd48bd5034f7067662870edf7ff3bf0cb76a";
  };

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    lpr=${mfc465cnlpr}/usr/local/Brother/Printer/mfc465cn
    dir=$out/usr/local/Brother/Printer/mfc465cn
    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" "$dir/cupswrapper/brcupsconfpt1"
    substituteInPlace $dir/cupswrapper/cupswrappermfc465cn \
      --replace "mkdir -p /usr" ": # mkdir -p /usr" \
      --replace '/''${printer_model}' "/mfc465cn" \
      --replace 'br''${printer_model}' "brmfc465cn" \
      --replace 'brlpdwrapper''${printer_model}' "brlpdwrappermfc465cn" \
      --replace 'filter''${printer_model}' "filtermfc465cn" \
      --replace ' ''${printer_name}' " MFC465CN" \
      --replace ' ''${device_name}' " MFC-465CN" \
      --replace '(''${device_name}' "(MFC-465CN" \
      --replace ':''${device_name}' ":MFC-465CN" \
      --replace '/''${device_name}' "/MFC-465CN" \
      --replace 'BR''${pcfilename}' "BR465" \
      --replace '/''${device_model}' "/Printer" \
      --replace '/usr/lib64/cups/filter/brlpdwrappermfc465cn' "$out/lib/cups/filter/brlpdwrappermfc465cn" \
      --replace '/usr/local/Brother/Printer/mfc465cn/lpd/filtermfc465cn' "$lpr/lpd/filtermfc465cn" \
      --replace '/usr/share/ppd/brmfc465cn.ppd' "$dir/cupswrapper/brmfc465.ppd" \
      --replace '/usr/share/cups/model/brmfc465cn.ppd' "$dir/cupswrapper/brmfc465.ppd" \
      --replace '/usr/lib/cups/filter/brlpdwrappermfc465cn' "$out/usr/lib/cups/filter/brlpdwrappermfc465cn" \
      --replace 'nup="psnup' "nup=\"${psutils}/bin/psnup" \
      --replace '/usr/bin/psnup' "${psutils}/bin/psnup" \
      --replace '/usr/local/Brother/Printer/mfc465cn/cupswrapper/brcupsconfpt1' "$dir/cupswrapper/brcupsconfpt1" \
      --replace '/usr/local/Brother/Printer/mfc465cn/inf' "$lpr/inf"
    # Create the PPD file from the cupswrapper file
    sed -n '/ENDOFPPDFILE1/,/ENDOFPPDFILE1/p' "$dir/cupswrapper/cupswrappermfc465cn" | head -n -1 | tail -n +2 > $dir/cupswrapper/brmfc465.ppd
    sed -n '/ENDOFPPDFILE_END/,/ENDOFPPDFILE_END/p' "$dir/cupswrapper/cupswrappermfc465cn" | head -n -1 | tail -n +2 >> $dir/cupswrapper/brmfc465.ppd
    chmod 644 $dir/cupswrapper/brmfc465.ppd
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model
    ln $dir/cupswrapper/cupswrappermfc465cn $out/lib/cups/filter
    ln $dir/cupswrapper/brmfc465.ppd $out/share/cups/model
    sed -n '/!ENDOFWFILTER!/,/!ENDOFWFILTER!/p' "$dir/cupswrapper/cupswrappermfc465cn" | sed '1 br; b; :r s/.*/printer_model=mfc465cn; cat <<!ENDOFWFILTER!/'  | bash > $out/lib/cups/filter/brlpdwrappermfc465cn
    sed -i "/#! \/bin\/sh/a PATH=${
      lib.makeBinPath [
        coreutils
        gnused
        gnugrep
      ]
    }:\$PATH" $out/lib/cups/filter/brlpdwrappermfc465cn
    chmod 755 $out/lib/cups/filter/brlpdwrappermfc465cn
  '';

  meta = with lib; {
    description = "Brother MFC-465CN CUPS wrapper driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ phrogg ];
  };
}
