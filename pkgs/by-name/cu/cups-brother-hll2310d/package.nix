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
  pname = "cups-brother-hll2310d";
  version = "4.0.0-1";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [ perl ];

  dontUnpack = true;

  src = fetchurl {
    url = "https://download.brother.com/pub/com/linux/linux/packages/hll2310dpdrv-${version}.i386.deb";
    sha256 = "1d21fp67xrjjvpn8dw0mvr2ykmaxkmx9q5317p41b27ankmg5sc3";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg-deb -x $src $out

    # delete unnecessary files for the current architecture
  ''
  + lib.concatMapStrings (arch: ''
    echo Deleting files for ${arch}
    rm -r "$out/opt/brother/Printers/HLL2310D/lpd/${arch}"
  '') (builtins.filter (arch: arch != stdenv.hostPlatform.linuxArch) arches)
  + ''

    # bundled scripts don't understand the arch subdirectories for some reason
    ln -s \
      "$out/opt/brother/Printers/HLL2310D/lpd/${stdenv.hostPlatform.linuxArch}/"* \
      "$out/opt/brother/Printers/HLL2310D/lpd/"

    # Fix global references and replace auto discovery mechanism with hardcoded values
    substituteInPlace $out/opt/brother/Printers/HLL2310D/lpd/lpdfilter \
      --replace /opt "$out/opt" \
      --replace "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/HLL2310D\"; #" \
      --replace "PRINTER =~" "PRINTER = \"HLL2310D\"; #"

    # Make sure all executables have the necessary runtime dependencies available
    find "$out" -executable -and -type f | while read file; do
      wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    done

    # Symlink filter and ppd into a location where CUPS will discover it
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln -s \
      $out/opt/brother/Printers/HLL2310D/lpd/lpdfilter \
      $out/lib/cups/filter/brother_lpdwrapper_HLL2310D

    ln -s \
      $out/opt/brother/Printers/HLL2310D/cupswrapper/brother-HLL2310D-cups-en.ppd \
      $out/share/cups/model/

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother HL-L2310D printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = map (arch: "${arch}-linux") arches;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=fr&lang=fr&prod=hll2310d_us_eu_as&os=128";
    maintainers = [ lib.maintainers.jderrac ];
  };
}
