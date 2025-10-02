{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  perl,
  gnused,
  ghostscript,
  file,
  coreutils,
  gnugrep,
  which,
}:

let
  arches = [
    "x86_64"
    "i686"
    "armv7l"
  ];

  runtimeDeps = [
    ghostscript
    file
    gnused
    gnugrep
    coreutils
    which
  ];
in

stdenv.mkDerivation rec {
  pname = "cups-brother-hll2350dw";
  version = "4.0.0-1";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [ perl ];

  dontUnpack = true;

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103566/hll2350dwpdrv-${version}.i386.deb";
    sha256 = "0b7hhln105agc3rwpi7cjlx5nf4d2yk9iksahdv3725nnd06lg46";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg-deb -x $src $out

    # delete unnecessary files for the current architecture
  ''
  + lib.concatMapStrings (arch: ''
    echo Deleting files for ${arch}
    rm -r "$out/opt/brother/Printers/HLL2350DW/lpd/${arch}"
  '') (builtins.filter (arch: arch != stdenv.hostPlatform.linuxArch) arches)
  + ''

    # bundled scripts don't understand the arch subdirectories for some reason
    ln -s \
      "$out/opt/brother/Printers/HLL2350DW/lpd/${stdenv.hostPlatform.linuxArch}/"* \
      "$out/opt/brother/Printers/HLL2350DW/lpd/"

    # Fix global references and replace auto discovery mechanism with hardcoded values
    substituteInPlace $out/opt/brother/Printers/HLL2350DW/lpd/lpdfilter \
      --replace /opt "$out/opt" \
      --replace "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/HLL2350DW\"; #" \
      --replace "PRINTER =~" "PRINTER = \"HLL2350DW\"; #"

    # Make sure all executables have the necessary runtime dependencies available
    find "$out" -executable -and -type f | while read file; do
      wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    done

    # Symlink filter and ppd into a location where CUPS will discover it
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln -s \
      $out/opt/brother/Printers/HLL2350DW/lpd/lpdfilter \
      $out/lib/cups/filter/brother_lpdwrapper_HLL2350DW

    ln -s \
      $out/opt/brother/Printers/HLL2350DW/cupswrapper/brother-HLL2350DW-cups-en.ppd \
      $out/share/cups/model/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother HL-L2350DW printer driver";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = builtins.map (arch: "${arch}-linux") arches;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=us_ot&lang=en&prod=hll2350dw_us_eu_as&os=128";
    maintainers = [ maintainers.sternenseemann ];
  };
}
