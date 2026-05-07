{
  lib,
  stdenvNoCC,
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
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mfcl5750dw";
  version = "3.5.1-1";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [ perl ];

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf102614/mfcl5750dwcupswrapper-${finalAttrs.version}.i386.deb";
    sha256 = "afe6d18e17d26348f3b8a4f9a003107984940c429a7dd193054303a21f5e65b5";
  };

  lpr_src = fetchurl {
    url = "https://download.brother.com/welcome/dlf102613/mfcl5750dwlpr-${finalAttrs.version}.i386.deb";
    sha256 = "b1b9c1f9ae8522a65fdd2db1e760aed835807ba593d001ac5471635a157cd1f1";
  };

  unpackPhase = ''
    dpkg-deb -x $src .
    dpkg-deb -x $lpr_src .
  '';

  patches = [
    # The brother lpdwrapper uses a temporary file to convey the printer settings.
    # The original settings file will be copied with "400" permissions and the "brprintconflsr3"
    # binary cannot alter the temporary file later on. This fixes the permissions so the can be modified.
    # Since this is all in briefly in the temporary directory of systemd-cups and not accessible by others,
    # it shouldn't be a security concern.
    ./fix-perm.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -ar opt $out/opt

    # delete unnecessary files for the current architecture
  ''
  + lib.concatMapStrings (arch: ''
    echo Deleting files for ${arch}
    rm -r "$out/opt/brother/Printers/MFCL5750DW/lpd/${arch}"
  '') (builtins.filter (arch: arch != stdenvNoCC.hostPlatform.linuxArch) arches)
  + ''
    # bundled scripts don't understand the arch subdirectories for some reason
    ln -s \
      "$out/opt/brother/Printers/MFCL5750DW/lpd/${stdenvNoCC.hostPlatform.linuxArch}/"* \
      "$out/opt/brother/Printers/MFCL5750DW/lpd/"

    # Fix global references and replace auto discovery mechanism with hardcoded values
    substituteInPlace $out/opt/brother/Printers/MFCL5750DW/lpd/lpdfilter \
      --replace "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/MFCL5750DW\"; #" \
      --replace "PRINTER =~" "PRINTER = \"MFCL5750DW\"; #"

    substituteInPlace $out/opt/brother/Printers/MFCL5750DW/cupswrapper/lpdwrapper \
    --replace "my \$basedir = C" "my \$basedir = \"$out/opt/brother/Printers/MFCL5750DW\" ; #" \
    --replace "PRINTER =~" "PRINTER = \"MFCL5750DW\"; #"

    # Make sure all executables have the necessary runtime dependencies available
    find "$out" -executable -and -type f | while read file; do
      wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    done
    # Symlink filter and ppd into a location where CUPS will discover it
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model
    mkdir -p $out/etc/opt/brother/Printers/MFCL5750DW/inf
    ln -s $out/opt/brother/Printers/MFCL5750DW/inf/brMFCL5750DWrc \
    $out/etc/opt/brother/Printers/MFCL5750DW/inf/brMFCL5750DWrc
    ln -s \
    $out/opt/brother/Printers/MFCL5750DW/cupswrapper/lpdwrapper \
    $out/lib/cups/filter/brother_lpdwrapper_MFCL5750DW
    ln -s \
    $out/opt/brother/Printers/MFCL5750DW/cupswrapper/brother-MFCL5750DW-cups-en.ppd \
    $out/share/cups/model/
    runHook postInstall
  '';
  meta = {
    homepage = "https://www.brother.com/";
    description = "Brother MFCL5750DW CUPS driver";
    license = lib.licenses.unfree;
    platforms = map (arch: "${arch}-linux") arches;
    maintainers = with lib.maintainers; [ qdlmcfresh ];
  };
})
