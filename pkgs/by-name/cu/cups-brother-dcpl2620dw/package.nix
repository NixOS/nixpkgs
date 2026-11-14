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

stdenv.mkDerivation rec {
  pname = "cups-brother-dcpl2620dw";
  version = "4.1.0-1";
  model = "DCPL2620DW";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [ perl ];

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf106010/dcpl2620dwpdrv-${version}.i386.deb";
    hash = "sha256-jl+Fh6wDzdHp768WivHEG1/KsIzly1c8bMLsYZgc8yo=";
  };

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
    rm -r "$out/opt/brother/Printers/${model}/lpd/${arch}"
  '') (builtins.filter (arch: arch != stdenv.hostPlatform.linuxArch) arches)
  + ''
    # bundled scripts don't understand the arch subdirectories for some reason
    ln -s \
      "$out/opt/brother/Printers/${model}/lpd/${stdenv.hostPlatform.linuxArch}/"* \
      "$out/opt/brother/Printers/${model}/lpd/"

    # Fix global references and replace auto discovery mechanism with hardcoded values
    substituteInPlace $out/opt/brother/Printers/${model}/lpd/lpdfilter \
      --replace "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/${model}\"; #" \
      --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
    substituteInPlace $out/opt/brother/Printers/${model}/cupswrapper/lpdwrapper \
      --replace "my \$basedir = C" "my \$basedir = \"$out/opt/brother/Printers/${model}\" ; #" \
      --replace "PRINTER =~" "PRINTER = \"${model}\"; #"

    # Make sure all executables have the necessary runtime dependencies available
    find "$out" -executable -and -type f | while read file; do
      wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    done

    # Symlink filter and ppd into a location where CUPS will discover it
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model
    mkdir -p $out/etc/opt/brother/Printers/${model}/inf

    ln -s $out/opt/brother/Printers/${model}/inf/br${model}rc \
          $out/etc/opt/brother/Printers/${model}/inf/br${model}rc
    ln -s \
      $out/opt/brother/Printers/${model}/cupswrapper/lpdwrapper \
      $out/lib/cups/filter/brother_lpdwrapper_${model}
    ln -s \
      $out/opt/brother/Printers/${model}/cupswrapper/brother-${model}-cups-en.ppd \
      $out/share/cups/model/
    runHook postInstall
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother ${model} printer driver";
    license = lib.licenses.unfree;
    platforms = map (arch: "${arch}-linux") arches;
    maintainers = with lib.maintainers; [ husjon ];
  };
}
