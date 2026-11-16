{
  lib,
  stdenv,
  fetchurl,

  config,
  acceptLicense ? config.dyalog.acceptLicense or false,

  autoPatchelfHook,
  coreutils,
  dpkg,
  gnused,
  makeWrapper,
  ncurses5,

  dotnetCorePackages,
  dotnetSupport ? false,

  alsa-lib,
  gtk3,
  libdrm,
  libGL,
  libgbm,
  nss,
  htmlRendererSupport ? false,

  unixodbc,
  sqaplSupport ? false,

  zeroFootprintRideSupport ? false,

  enableDocs ? false,
}:

let
  dyalogHome = "$out/lib/dyalog";

  makeWrapperArgs = lib.optional dotnetSupport "--set DOTNET_ROOT ${dotnetCorePackages.runtime_10_0}/share/dotnet";

  maplWrapperArgs = makeWrapperArgs ++ [
    "--suffix PATH : ${
      lib.makeBinPath [
        coreutils
        gnused
      ]
    }"
  ];

  licenseUrl = "https://www.dyalog.com/uploads/documents/Developer_Software_Licence.pdf";

  licenseDisclaimer = ''
    Dyalog is a licenced software. Dyalog licences do not include a licence to distribute Dyalog with your work.
    For non-commercial purposes, a Basic Licence is granted when you accept the conditions and download a free copy of Dyalog.

    More details about the license can be found here: ${licenseUrl}

    If you agree to these terms, you can either override this package:
    `dyalog.override { acceptLicense = true; }`

    or you can set the following nixpkgs config option:
    `config.dyalog.acceptLicense = true;`
  '';

  inherit (stdenv.hostPlatform) system isAarch;

  htmlRendererNotOnAarch = ''
    The HTMLRenderer is not currently supported on ${system}.
    https://docs.dyalog.com/20.0/release-notes/announcements/#new-linux-platform
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dyalog";
  version = "21.0.55109";
  shortVersion = lib.versions.majorMinor finalAttrs.version;

  passthru.sources =
    let
      fetchArtifact =
        {
          prefix,
          suffix,
          hash,
        }:
        fetchurl {
          url = "https://dyalog.com/uploads/php/download.dyalog.com/download.php?file=${finalAttrs.shortVersion}/${prefix}_${finalAttrs.version}_${suffix}";
          inherit hash;
        };
    in
    {
      "x86_64-linux" = fetchArtifact {
        prefix = "linux_64";
        suffix = "unicode.x86_64.deb";
        hash = "sha256-A9ncL6IvpDTqkaYKbTr0dnS5B7ui24wPMLknbIr+UJo=";
      };
      "aarch64-linux" = fetchArtifact {
        prefix = "linux_64";
        suffix = "unicode.aarch64.deb";
        hash = "sha256-esJSpOfnLUi/wobVhTk0KaMRD03UiWpGVMzL5VqKdRM=";
      };
    };

  passthru.updateScript = ./update.sh;

  src =
    assert !acceptLicense -> throw licenseDisclaimer;
    assert htmlRendererSupport && isAarch -> throw htmlRendererNotOnAarch;
    finalAttrs.passthru.sources.${system};

  outputs = [ "out" ] ++ lib.optional enableDocs "doc";

  postUnpack = ''
    sourceRoot=$sourceRoot/opt/mdyalog/${finalAttrs.shortVersion}/64/unicode
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc) # Used by Conga and .NET Bridge
    ncurses5 # Used by the dyalog binary to correctly display in the terminal
  ]
  ++ lib.optionals htmlRendererSupport [
    alsa-lib
    gtk3
    libdrm
    libGL
    libgbm
    nss
  ]
  ++ lib.optional sqaplSupport unixodbc;

  # See which files are not really important: `https://github.com/Dyalog/DyalogDocker/blob/master/rmfiles.sh`
  installPhase = ''
    runHook preInstall

    mkdir -p ${dyalogHome}
    cp -r aplfmt aplkeys apltrans Experimental fonts Library PublicCACerts SALT StartupSession ${dyalogHome}
    cp aplkeys.sh default.dse dyalog dyalogc dyalog.rt dyalog.dcfg.template dyalog.ver.dcfg.template languagebar.json mapl StartupSession.aplf ${dyalogHome}

    mkdir ${dyalogHome}/lib
    cp lib/{conga37_64.so,dyalog64.so,libconga37ssl64.so} ${dyalogHome}/lib

    # Only keep the most useful workspaces
    mkdir ${dyalogHome}/ws
    cp ws/{conga,dfns,isolate,loaddata,salt,sharpplot,util}.dws ${dyalogHome}/ws
  ''
  # Not shipped on aarch64; dyalog loads it at startup even without the HTMLRenderer
  + lib.optionalString (!isAarch) ''
    cp unix_gui.so ${dyalogHome}
  ''
  + lib.optionalString dotnetSupport ''
    cp libnethost.so Dyalog.Net.Bridge.* Lokad.ILPack.dll ${dyalogHome}
  ''
  + lib.optionalString htmlRendererSupport ''
    cp -r locales ${dyalogHome}
    cp libcef.so libEGL.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1 ${dyalogHome}
    cp chrome-sandbox icudtl.dat v8_context_snapshot.bin vk_swiftshader_icd.json *.pak ${dyalogHome}
    cp HtmlRendererPlugin.plugin ${dyalogHome}
    cp lib/htmlrenderer.so ${dyalogHome}/lib
  ''
  + lib.optionalString sqaplSupport ''
    cp lib/cxdya67u64u.so ${dyalogHome}/lib
    cp ws/sqapl.dws ${dyalogHome}/ws
    cp odbc.ini.sample sqapl.err sqapl.ini ${dyalogHome}
  ''
  + lib.optionalString zeroFootprintRideSupport ''
    cp -r RIDEapp ${dyalogHome}
  ''
  + lib.optionalString enableDocs ''
    mkdir -p $doc/share/doc/dyalog
    cp -r help/* $doc/share/doc/dyalog
    ln -s $doc/share/doc/dyalog ${dyalogHome}/help
  ''
  + ''
    install -Dm644 dyalog.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 dyalog.desktop -t $out/share/applications
    install -Dm644 fonts/*.ttf -t $out/share/fonts/truetype

    # Like upstream's /usr/bin/dyalog: mapl reads ~/.dyalog and the serial, and handles -rt/-bg/-kbd
    for exec in "dyalog" "mapl"; do
        makeWrapper ${dyalogHome}/mapl $out/bin/$exec ${toString maplWrapperArgs}
    done

    # Upstream's dyalogscript starts the interpreter directly, not through mapl
    makeWrapper ${dyalogHome}/dyalog $out/libexec/dyalog/dyalog ${toString makeWrapperArgs}
    install -Dm755 scriptbin/dyalogscript $out/bin/dyalogscript
    substituteInPlace $out/bin/dyalogscript \
        --replace-fail 'INSTALLDIR="/opt/mdyalog/${finalAttrs.shortVersion}/64/unicode"' "INSTALLDIR=\"${dyalogHome}\"" \
        --replace-fail ': ''${SCRIPTDIR:=$INSTALLDIR}' "SCRIPTDIR=\"$out/libexec/dyalog\""

    runHook postInstall
  '';

  # Register some undeclared runtime dependencies to be patched in by autoPatchelfHook
  # Note: dyalog.rt is used internally to run child APL processes in
  preFixup = ''
    for exec in "dyalog" "dyalog.rt"; do
        patchelf ${dyalogHome}/$exec --add-needed libncurses.so
    done
  ''
  + lib.optionalString htmlRendererSupport ''
    patchelf ${dyalogHome}/libcef.so --add-needed libudev.so --add-needed libGL.so
  '';

  # Conga, SQAPL and .NET are loaded at runtime, so autoPatchelfHook cannot notice when they break
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME=$(mktemp -d)

    # usage: check EXPECTED APL-LINE...
    check() {
      local expected=$1
      shift
      printf '%s\n' "$@" > check.apls
      # dyalog -script terminates output lines with \r
      local output=$($out/bin/dyalogscript check.apls | tr '\r' '\n')
      if [[ "$output" != "$expected" ]]; then
        echo "dyalogscript check failed for: $*"
        echo "expected '$expected', got '$output'"
        exit 1
      fi
    }

    check 55 '⎕←+/⍳10'
    check 0 "'DRC'⎕CY'conga'" "⎕←⊃DRC.Init'''"

    echo '⎕←+/⍳10' > mapl.apls
    if [[ "$($out/bin/dyalog -script mapl.apls | tr '\r' '\n')" != 55 || ! -s $HOME/.dyalog/dyalog.dcfg ]]; then
      echo "bin/dyalog did not run through mapl"
      exit 1
    fi
  ''
  + lib.optionalString dotnetSupport ''
    check 1 "⎕USING←'System'" '⎕←2000<DateTime.Now.Year'
  ''
  + lib.optionalString sqaplSupport ''
    check 0 "'SQA'⎕CY'sqapl'" "⎕←⊃SQA.Init'''"
  ''
  + ''
    runHook postInstallCheck
  '';

  meta = {
    changelog = "https://dyalog.com/dyalog/dyalog-versions/${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.shortVersion
    }.htm";
    description = "Dyalog APL interpreter";
    homepage = "https://www.dyalog.com";
    license = lib.licenses.mkLicense {
      shortName = "dyalog";
      fullName = "Dyalog License";
      url = licenseUrl;
      free = false;
    };
    mainProgram = "dyalog";
    maintainers = with lib.maintainers; [
      tomasajt
      markus1189
    ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
