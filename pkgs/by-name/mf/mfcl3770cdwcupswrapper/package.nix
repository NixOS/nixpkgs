{
  fetchurl,
  lib,
  mfcl3770cdwlpr,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "mfcl3770cdwcupswrapper";
  version = "1.0.2-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103935/mfcl3770cdwpdrv-${finalAttrs.version}.i386.deb";
    sha256 = "09fhbzhpjymhkwxqyxzv24b06ybmajr6872yp7pri39595mhrvay";
  };

  nativeBuildInputs = [
    pkgsi686Linux.dpkg
    pkgsi686Linux.makeWrapper
    pkgsi686Linux.autoPatchelfHook
  ];

  unpackPhase = "dpkg-deb -x $src $out";

  installPhase = ''
    basedir=${mfcl3770cdwlpr}/opt/brother/Printers/mfcl3770cdw
    dir=$out/opt/brother/Printers/mfcl3770cdw

    substituteInPlace $dir/cupswrapper/brother_lpdwrapper_mfcl3770cdw \
      --replace-fail /usr/bin/perl ${pkgsi686Linux.perl}/bin/perl \
      --replace-fail "basedir =~" "basedir = \"$basedir\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"mfcl3770cdw\"; #"

    wrapProgram $dir/cupswrapper/brother_lpdwrapper_mfcl3770cdw \
      --prefix PATH : ${
        lib.makeBinPath [
          pkgsi686Linux.coreutils
          pkgsi686Linux.gnugrep
          pkgsi686Linux.gnused
        ]
      }

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln -s $dir/cupswrapper/brother_lpdwrapper_mfcl3770cdw $out/lib/cups/filter/brother_lpdwrapper_mfcl3770cdw
    ln -s $dir/cupswrapper/brother_mfcl3770cdw_printer_en.ppd $out/share/cups/model/brother_mfcl3770cdw_printer_en.ppd
  '';

  meta = {
    description = "Brother MFCL3770CDW CUPS wrapper driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ lib.maintainers.steveej ];
  };
})
