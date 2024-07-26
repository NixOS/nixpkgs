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
stdenv.mkDerivation (finalAttrs: {
  pname = "brother-dcpl2550dw";
  version = "4.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103577/dcpl2550dwpdrv-${finalAttrs.version}.i386.deb";
    hash = "sha256-gGW8KDXlmYSMxvI29pfXd/lusg4rd4HaXiGkbBnUuQY=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [ perl ];

  patches = [
    # The brother lpdwrapper uses a temporary file to convey the printer settings.
    # The original settings file will be copied with "400" permissions and the "brprintconflsr3"
    # binary cannot alter the temporary file later on. This fixes the permissions so the can be modified.
    # Since this is all in briefly in the temporary directory of systemd-cups and not accessible by others,
    # it shouldn't be a security concern.
    ./fix-perm.patch
  ];

  installPhase =
    ''
      runHook preInstall
      mkdir -p $out
      cp -ar opt $out/opt
      # delete unnecessary files for the current architecture
    ''
    + lib.concatMapStrings (arch: ''
      echo Deleting files for ${arch}
      rm -r "$out/opt/brother/Printers/DCPL2550DW/lpd/${arch}"
    '') (builtins.filter (arch: arch != stdenv.hostPlatform.linuxArch) arches)
    + ''
      # bundled scripts don't understand the arch subdirectories for some reason
      ln -s \
        "$out/opt/brother/Printers/DCPL2550DW/lpd/${stdenv.hostPlatform.linuxArch}/"* \
        "$out/opt/brother/Printers/DCPL2550DW/lpd/"

      # Fix global references and replace auto discovery mechanism with hardcoded values
      substituteInPlace $out/opt/brother/Printers/DCPL2550DW/lpd/lpdfilter \
        --replace-fail "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/DCPL2550DW\"; #" \
        --replace-fail "PRINTER =~" "PRINTER = \"DCPL2550DW\"; #"
      substituteInPlace $out/opt/brother/Printers/DCPL2550DW/cupswrapper/lpdwrapper \
        --replace-fail "my \$basedir = C" "my \$basedir = \"$out/opt/brother/Printers/DCPL2550DW\" ; #" \
        --replace-fail "PRINTER =~" "PRINTER = \"DCPL2550DW\"; #"

      # Make sure all executables have the necessary runtime dependencies available
      find "$out" -executable -and -type f | while read file; do
        wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
      done

      # Symlink filter and ppd into a location where CUPS will discover it
      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model
      mkdir -p $out/etc/opt/brother/Printers/DCPL2550DW/inf

      ln -s $out/opt/brother/Printers/DCPL2550DW/inf/brDCPL2550DWrc \
        $out/etc/opt/brother/Printers/DCPL2550DW/inf/brDCPL2550DWrc
      ln -s \
        $out/opt/brother/Printers/DCPL2550DW/cupswrapper/lpdwrapper \
        $out/lib/cups/filter/brother_lpdwrapper_DCPL2550DW
      ln -s \
        $out/opt/brother/Printers/DCPL2550DW/cupswrapper/brother-DCPL2550DW-cups-en.ppd \
        $out/share/cups/model/
      runHook postInstall
    '';

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother DCPL2550DW printer driver";
    longDescription = ''
      Install this with printing services:
      ```
      ...
        services.printing.enable = true;
        services.printing.drivers = [
          pkgs.brother-dcpl2550dw
        ];
      ...
      ```
    '';
    license = licenses.unfree;
    platforms = builtins.map (arch: "${arch}-linux") arches;
    maintainers = [ maintainers.p4p4j0hn ];
  };
})
