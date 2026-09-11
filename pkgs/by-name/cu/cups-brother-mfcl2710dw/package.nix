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
stdenv.mkDerivation (finalAttrs: {
  pname = "cups-brother-mfcl2710dw";
  version = "4.0.0-1";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [ perl ];

  dontUnpack = true;

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103526/mfcl2710dwpdrv-${finalAttrs.version}.i386.deb";
    hash = "sha256-OOTvbCuyxw4k01CTMuBqG2boMN13q5xC7LacaweGmyw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg-deb -x $src $out

    # delete unnecessary files for the current architecture
  ''
  + lib.concatMapStrings (arch: ''
    echo Deleting files for ${arch}
    rm -r "$out/opt/brother/Printers/MFCL2710DW/lpd/${arch}"
  '') (builtins.filter (arch: arch != stdenv.hostPlatform.linuxArch) arches)
  + ''

    # bundled scripts don't understand the arch subdirectories for some reason
    ln -s \
      "$out/opt/brother/Printers/MFCL2710DW/lpd/${stdenv.hostPlatform.linuxArch}/"* \
      "$out/opt/brother/Printers/MFCL2710DW/lpd/"

    # Fix global references and replace auto discovery mechanism with hardcoded values
    substituteInPlace $out/opt/brother/Printers/MFCL2710DW/lpd/lpdfilter \
      --replace-fail /opt "$out/opt" \
      --replace-fail "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/MFCL2710DW\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"MFCL2710DW\"; #"

    # Make sure all executables have the necessary runtime dependencies available
    find "$out" -executable -and -type f | while read file; do
      wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    done

    # Symlink filter and ppd into a location where CUPS will discover it
    mkdir -p $out/lib/cups/filter $out/share/cups/model

    ln -s \
      $out/opt/brother/Printers/MFCL2710DW/lpd/lpdfilter \
      $out/lib/cups/filter/brother_lpdwrapper_MFCL2710DW

    ln -s \
      $out/opt/brother/Printers/MFCL2710DW/cupswrapper/brother-MFCL2710DW-cups-en.ppd \
      $out/share/cups/model/

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother MFC-L2710DW printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = map (arch: "${arch}-linux") arches;
    maintainers = with lib.maintainers; [ rosebeats ];
  };
})
