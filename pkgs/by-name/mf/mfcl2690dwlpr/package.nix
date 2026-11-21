{
  coreutils,
  dpkg,
  fetchurl,
  file,
  ghostscript,
  gnugrep,
  gnused,
  lib,
  makeWrapper,
  patchelf,
  perl,
  pkgs,
  stdenv,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfcl2690dwlpr";
  version = "4.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105065/mfcl2690dwpdrv-${finalAttrs.version}.i386.deb";
    hash = "sha256-dl2knx8NaO02ulU+bmCqUDDoeEW3Sv4NfUbrqyirUlY=";
  };

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
    patchelf
  ];

  dontPatchELF = true;
  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    dir=$out/opt/brother/Printers/MFCL2690DW
    filter=$dir/lpd/lpdfilter

    substituteInPlace $filter \
      --replace-fail '/usr/bin/perl' '${lib.getExe perl}' \
      --replace-fail '$basedir =~ s/\/lpd\/.*$//g;' '$basedir = "'"$dir"'";' \
      --replace-fail '$PRINTER =~ s/^\/opt\/.*\/Printers\///g;' '$PRINTER = "MFCL2690DW";'

    ln -s $dir/lpd/x86_64/rawtobr3 $dir/lpd/rawtobr3

    wrapProgram $filter \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          file
          ghostscript
          gnugrep
          gnused
          which
        ]
      }

    for f in $dir/lpd/x86_64/brprintconflsr3 $dir/lpd/x86_64/rawtobr3; do
      patchelf --set-interpreter \
        ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 \
        $f
    done

    for f in $dir/lpd/i686/brprintconflsr3 $dir/lpd/i686/rawtobr3; do
      patchelf --set-interpreter \
        ${pkgs.pkgsi686Linux.glibc}/lib/ld-linux.so.2 \
        $f
    done
  '';

  meta = {
    description = "Brother MFC-L2690DW LPR printer driver";
    homepage = "https://www.brother.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
