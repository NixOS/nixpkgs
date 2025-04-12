{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  gnused,
  coreutils,
  psutils,
  gnugrep,
  ghostscript,
  file,
  a2ps,
  gawk,
  which,
  pkgsi686Linux,
}:

stdenv.mkDerivation rec {
  pname = "cups-brother-${model}";
  version = "1.1.4-0";
  lprVersion = "1.1.2-1";

  model = "hl3170cdw";
  cupsFileNo = "006743";
  lprFileNo = "007056";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf${cupsFileNo}/${model}_cupswrapper_GPL_source_${version}.tar.gz";
    hash = "sha256-E3GSwiMRkuiCIJYkDozoYUPfOqvopPqPPQt1uaMDEAU=";
  };

  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf${lprFileNo}/${model}lpr-${lprVersion}.i386.deb";
    hash = "sha256-N1GjQHth5k4qhbfWLInzub9DcNsee4gKc3EW2WIfrko=";
  };

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];

  preUnpack = ''
    dpkg-deb -x ${lprdeb} $out
  '';

  prePatch = ''
    substituteInPlace brcupsconfig/brcups_commands.h \
      --replace-fail "brprintconf[30]=\"" "brprintconf[130]=\"$out/usr/bin/"

    substituteInPlace brcupsconfig/brcupsconfig.c \
      --replace-fail "exec[300]" "exec[400]"
  '';

  makeFlags = [ "-C brcupsconfig" ];

  installPhase = ''
    runHook preInstall

    # cups install
    dir=$out/opt/brother/Printers/${model}

    # Extract the true brother_lpdwrapper_MODEL filter embedded in cupswrapperMODEL by
    # slicing out the relevant parts for the writing the embedded file, then running that.
    sed -n -e '/tmp_filter=/c\tmp_filter=lpdwrapper'  -e ' 1,/device_model=/p ; /<<!ENDOFWFILTER/,/!ENDOFWFILTER/p ; ' \
      cupswrapper/cupswrapper${model} > lpdwrapperbuilder
    sh lpdwrapperbuilder
    chmod +x lpdwrapper
    mkdir -p $out/lib/cups/filter
    cp lpdwrapper $out/lib/cups/filter/brother_lpdwrapper_${model}

    mkdir -p $out/share/cups/model/Brother
    cp PPD/brother_${model}_printer_en.ppd $out/share/cups/model/Brother/brother_${model}_printer_en.ppd

    mkdir -p $dir/cupswrapper/
    cp brcupsconfig/brcupsconfpt1 $dir/cupswrapper/

    runHook postInstall
  '';

  preFixup = ''
    # lpr fixup
    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2

    substituteInPlace $dir/lpd/filter${model} \
      --replace-fail /opt "$out/opt"
    substituteInPlace $dir/inf/setupPrintcapij \
      --replace-fail /opt "$out/opt" \
      --replace-fail printcap.local printcap

    wrapProgram $dir/lpd/filter${model} \
      --prefix PATH ":" ${
        lib.makeBinPath [
          ghostscript
          a2ps
          file
          gnused
          coreutils
        ]
      }

    wrapProgram $dir/inf/setupPrintcapij \
      --prefix PATH ":" ${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }

    wrapProgram $dir/lpd/psconvertij2 \
      --prefix PATH ":" ${
        lib.makeBinPath [
          ghostscript
          gnused
          coreutils
          gawk
          which
        ]
      }

    patchelf --set-interpreter "$interpreter" "$dir/lpd/br${model}filter"
    patchelf --set-interpreter "$interpreter" "$out/usr/bin/brprintconf_${model}"

    wrapProgram $dir/lpd/br${model}filter \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS "/opt=$out/opt"

    wrapProgram $out/usr/bin/brprintconf_${model} \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS "/opt=$out/opt"

    # cups fixup
    substituteInPlace $out/lib/cups/filter/brother_lpdwrapper_${model} \
      --replace-fail /opt/brother/Printers/${model} "$dir" \
      --replace-fail /usr/bin/psnup "${psutils}/bin/psnup" \
      --replace-fail /usr/share/cups/model/Brother "$out/share/cups/model/Brother"

    wrapProgram $out/lib/cups/filter/brother_lpdwrapper_${model} \
      --prefix PATH ":" ${
        lib.makeBinPath [
          coreutils
          psutils
          gnused
          gnugrep
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://www.brother.com/";
    description = "Brother ${model} printer driver";
    sourceProvenance = with sourceTypes; [
      binaryNativeCode
      fromSource
    ];
    license = with licenses; [
      unfree
      gpl2Plus
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=${model}_all&os=128";
    maintainers = with maintainers; [ luna_1024 ];
  };
}
