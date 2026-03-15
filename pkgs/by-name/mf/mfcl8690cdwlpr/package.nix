{
  coreutils,
  dpkg,
  fetchurl,
  file,
  ghostscript,
  gnugrep,
  gnused,
  makeWrapper,
  perl,
  pkgs,
  lib,
  stdenv,
  which,
}:

let
  myPatchElf = file: ''
    patchelf --set-interpreter \
      ${pkgs.pkgsi686Linux.glibc}/lib/ld-linux.so.2 \
      ${file}
  '';
in
stdenv.mkDerivation rec {
  pname = "mfcl8690cdwlpr";
  version = "1.5.0-3";

  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf103241/${pname}-${version}.i386.deb";
    sha256 = "0wirhw5wvrv6nz14ldgnmxsbbz97vdslcmbli12libwlhkl2hxh9";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontUnpack = true;
  dontPatchELF = true;

  installPhase = ''
    dpkg-deb -x $src $out

    dir=$out/opt/brother/Printers/mfcl8690cdw
    filter=$dir/lpd/filter_mfcl8690cdw

    substituteInPlace $filter \
      --replace-fail /usr/bin/perl ${perl}/bin/perl \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir/\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"mfcl8690cdw\"; #"

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

    # Adding x86_64 binaries
    ${myPatchElf "$dir/lpd/x86_64/brmfcl8690cdwfilter"}
    ${myPatchElf "$dir/lpd/x86_64/brprintconf_mfcl8690cdw"}
  '';

  meta = {
    description = "Brother MFC-L8690CDW LPR printer driver";
    homepage = "https://www.brother.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
