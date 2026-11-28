{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  patchelf,
  pkgsi686Linux,
  coreutils,
  gnugrep,
  gnused,
  gawk,
  file,
  ghostscript,
  a2ps,
  which,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "mfc1810lpr";
  version = "3.0.1-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf100414/${pname}-${version}.i386.deb";
    hash = "sha256-O4BCwcSi1h9b8T42eCZdE1eiBr66nxH4yEFWp2mgW/Y=";
  };

  nativeBuildInputs = [
    dpkg
    patchelf
    makeWrapper
  ];

  unpackPhase = ''
    runHook preUnpack
    mkdir src && cd src
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt $out/
    [ -d usr ] && cp -r usr $out/
    [ -d var ] && cp -r var $out/

    dir=$out/opt/brother/Printers/MFC1810

    # Brother ships 32-bit i386 binaries: point them at the 32-bit loader.
    for f in $(find $out -type f); do
      if patchelf --print-interpreter "$f" >/dev/null 2>&1; then
        chmod +x "$f"
        patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 "$f"
      fi
    done

    # Scripts hardcode /opt/brother/...: rewrite to the store path.
    for f in $(grep -rIl "/opt/brother/Printers/MFC1810" $out); do
      substituteInPlace "$f" --replace-fail "/opt/brother/Printers/MFC1810" "$dir"
    done

    # setupPrintcap builds the same path from a positional-arg variable
    substituteInPlace "$dir/inf/setupPrintcap" \
      --replace-fail '/opt/brother/Printers/$BRPRINTER_NAME/lpd/filter_''${BRPRINTER_NAME}' "$dir/lpd/filter_MFC1810"

    # Shell-script filters need standard tools on PATH.
    for f in $dir/lpd/filter*; do
      if head -c2 "$f" | grep -q '#!'; then
        wrapProgram "$f" --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            gnugrep
            gnused
            gawk
            file
            ghostscript
            a2ps
            which
          ]
        }
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Brother MFC-1810 LPR driver";
    homepage = "https://support.brother.com/g/b/producttop.aspx?c=gb&lang=en&prod=mfc1810_all";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [ ee5cd7d5d ];
  };
}
