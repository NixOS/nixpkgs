{
  stdenvNoCC,
  lib,
  fetchurl,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
  patchelf,
  pkgsi686Linux,
  coreutils,
  ghostscript,
  gnugrep,
  gnused,
  a2ps,
  file,
  psutils,
  which,
}:

let
  model = "mfc6490cw";
  version = "1.1.2-2";
  reldir = "usr/local/Brother/Printer/${model}";
in

stdenvNoCC.mkDerivation rec {

  __structuredAttrs = true;

  pname = "brother-${model}";
  inherit version;

  srcLpr = fetchurl {
    url = "https://download.brother.com/welcome/dlf006180/${model}lpr-${version}.i386.deb";
    sha256 = "1p33aal3dv3r03v9nbafrzx2bhij34hrsg2d71kwm738a8n18vnj";
  };

  srcCups = fetchurl {
    url = "https://download.brother.com/welcome/dlf006182/${model}cupswrapper-${version}.i386.deb";
    sha256 = "1msj1hz7i1jn806gkd4nahwdc4rff030fzp37pfdxg9hjc88vfxi";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
    patchelf
  ];

  buildInputs = [
    pkgsi686Linux.glibc
    pkgsi686Linux.gcc.cc.lib
  ];

  strictDeps = true;
  dontUnpack = true;

  installPhase =
    let
      filterBinPath = lib.makeBinPath [
        coreutils
        ghostscript
        gnugrep
        gnused
        which
        a2ps
        file
        psutils
      ];

      cupsBinPath = lib.makeBinPath [
        coreutils
        ghostscript
        gnugrep
        gnused
        psutils
      ];

      filterScript = "$out/${reldir}/lpd/filter${model}";
      wrapperScript = "$out/${reldir}/cupswrapper/cupswrapper${model}";
      lpdWrapper = "$out/lib/cups/filter/brlpdwrapper${model}";
      ppd = "$out/share/cups/model/br${model}.ppd";
      rcFile = "$out/${reldir}/inf/br${model}rc";
    in
    ''
      runHook preInstall

      mkdir -p lpr cups
      dpkg-deb -x "$srcLpr" lpr
      dpkg-deb -x "$srcCups" cups

      mkdir -p "$out/${reldir}"/{lpd,cupswrapper,inf}
      mkdir -p "$out/share/cups/model"
      mkdir -p "$out/lib/cups/filter"

      cp -r lpr/${reldir}/. "$out/${reldir}/"
      cp -r cups/${reldir}/. "$out/${reldir}/"


      # Force A4 paper size:
      # Upstream Brother driver defaults to Letter and may switch to A3 behavior
      # when not patched. The configuration file cannot be reliably modified at runtime
      # because it resides in the Nix store (read-only), and Brother's tools do not
      # correctly update it post-installation.
      # Force A4 instead of Letter
      sed -i 's/PaperType=Letter/PaperType=A4/' "${rcFile}"

      # Patch LPD filter
      substituteInPlace "${filterScript}" \
        --replace-warn "BR_PRT_PATH=" "BR_PRT_PATH=\"$out/${reldir}\" #"

      chmod +x "${filterScript}"

      wrapProgram "${filterScript}" \
        --prefix PATH : "${filterBinPath}:$out/${reldir}/cupswrapper"

      # IMPORTANT: Brother wrapper script relies on runtime variables
      substituteInPlace "${wrapperScript}" \
        --replace-warn '/usr/local/Brother/''${device_model}/''${printer_model}/lpd/filter''${printer_model}' \
                       "${filterScript}" \
        --replace-warn '/usr/local/Brother/''${device_model}/''${printer_model}' \
                       "$out/${reldir}" \
        --replace-warn '/usr/share/cups/model' "$out/share/cups/model" \
        --replace-warn '/usr/lib/cups/filter' "$out/lib/cups/filter" \
        --replace-warn '/usr/lib64/cups/filter' "$out/lib/cups/filter" \
        --replace-warn '/usr/lib/cups/backend' "$out/lib/cups/backend" \
        --replace-warn '/usr/lib64/cups/backend' "$out/lib/cups/backend" \
        --replace-warn '/usr/bin/psnup' '${psutils}/bin/psnup'

      chmod +x "${wrapperScript}"

      PATH="${coreutils}/bin:${gnugrep}/bin:${gnused}/bin:${ghostscript}/bin" \
        "${wrapperScript}" || echo "cupswrapper exited non-zero (ignored)"

      # Fix PPD defaults
      sed -i \
        -e 's/*DefaultPageSize: Letter/*DefaultPageSize: A4/' \
        -e 's/*DefaultPageRegion: Letter/*DefaultPageRegion: A4/' \
        "${ppd}"

      # Ensure CUPS filter exists
      test -f "${lpdWrapper}"

      wrapProgram "${lpdWrapper}" \
        --prefix PATH : "${cupsBinPath}:$out/${reldir}/cupswrapper"

      runHook postInstall
    '';

  postFixup =
    let
      interp = "${pkgsi686Linux.glibc}/lib/ld-linux.so.2";
      rpath = lib.makeLibraryPath [
        pkgsi686Linux.glibc
        pkgsi686Linux.gcc.cc.lib
      ];

      bins = [
        "${reldir}/lpd/br${model}filter"
        "${reldir}/cupswrapper/brcupsconfpt1"
      ];
    in
    ''
      ${lib.concatMapStrings (bin: ''
        patchelf \
          --set-interpreter "${interp}" \
          --set-rpath "${rpath}" \
          "$out/${bin}"
      '') bins}
    '';

  meta = with lib; {
    description = "Brother MFC-6490CW printer driver (LPR + CUPS wrapper)";
    homepage = "https://www.brother.com/";
    license = licenses.unfreeRedistributable;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ XanderTheDev ];
  };
}
