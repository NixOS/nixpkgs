{
  pkgsi686Linux,
  fetchurl,
  lib,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "mfcl3770cdwdrv";
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
    dir="$out/opt/brother/Printers/mfcl3770cdw/"

    substituteInPlace $dir/lpd/filter_mfcl3770cdw \
      --replace-fail /usr/bin/perl ${pkgsi686Linux.perl}/bin/perl \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"mfcl3770cdw\"; #"

    wrapProgram $dir/lpd/filter_mfcl3770cdw \
      --prefix PATH : ${
        lib.makeBinPath [
          pkgsi686Linux.coreutils
          pkgsi686Linux.ghostscript
          pkgsi686Linux.gnugrep
          pkgsi686Linux.gnused
          pkgsi686Linux.which
        ]
      }
  '';

  meta = {
    description = "Brother MCL3770CDW driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ lib.maintainers.steveej ];
  };
})
