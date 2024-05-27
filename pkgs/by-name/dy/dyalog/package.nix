{ lib
, stdenv
, fetchurl

, config
, acceptLicense ? config.dyalog.acceptLicense or false

, autoPatchelfHook
, dpkg
, makeWrapper
, ncurses5

, dotnet-sdk_8
, dotnetSupport ? false

, alsa-lib
, gtk3
, libdrm
, libGL
, mesa
, nss
, htmlRendererSupport ? false

, unixODBC
, sqaplSupport ? false

, zeroFootprintRideSupport ? false

, enableDocs ? false
}:

let
  dyalogHome = "$out/lib/dyalog";

  makeWrapperArgs = lib.optional dotnetSupport "--set DOTNET_ROOT ${dotnet-sdk_8}";

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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dyalog";
  version = "19.0.48958";
  shortVersion = lib.versions.majorMinor finalAttrs.version;

  src =
    assert !acceptLicense -> throw licenseDisclaimer;
    fetchurl {
      url = "https://download.dyalog.com/download.php?file=${finalAttrs.shortVersion}/linux_64_${finalAttrs.version}_unicode.x86_64.deb";
      hash = "sha256-+L9XI7Knt91sG/0E3GFSeqjD9Zs+1n72MDfvsXnr77M=";
    };

  outputs = [ "out" ] ++ lib.optional enableDocs "doc";

  postUnpack = ''
    sourceRoot=$sourceRoot/opt/mdyalog/${finalAttrs.shortVersion}/64/unicode
  '';

  patches = [ ./dyalogscript.patch ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib # Used by Conga and .NET Bridge
    ncurses5 # Used by the dyalog binary to correctly display in the terminal
  ]
  ++ lib.optionals htmlRendererSupport [
    alsa-lib
    gtk3
    libdrm
    libGL
    mesa
    nss
  ]
  ++ lib.optional sqaplSupport unixODBC;

  # See which files are not really important: `https://github.com/Dyalog/DyalogDocker/blob/master/rmfiles.sh`
  installPhase = ''
    runHook preInstall

    mkdir -p ${dyalogHome}
    cp -r aplfmt aplkeys apltrans Experimental fonts Library PublicCACerts SALT StartupSession ${dyalogHome}
    cp aplkeys.sh default.dse dyalog dyalogc dyalog.rt dyalog.dcfg.template dyalog.ver.dcfg.template languagebar.json mapl StartupSession.aplf ${dyalogHome}

    mkdir ${dyalogHome}/lib
    cp lib/{conga35_64.so,dyalog64.so,libconga35ssl64.so} ${dyalogHome}/lib

    # Only keep the most useful workspaces
    mkdir ${dyalogHome}/ws
    cp ws/{conga,dfns,isolate,loaddata,salt,sharpplot,util}.dws ${dyalogHome}/ws
  ''
  + lib.optionalString dotnetSupport ''
    cp libnethost.so Dyalog.Net.Bridge.* Lokad.ILPack.dll ${dyalogHome}
  ''
  + lib.optionalString htmlRendererSupport ''
    cp -r locales ${dyalogHome}
    cp libcef.so libEGL.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1 ${dyalogHome}
    cp chrome-sandbox icudtl.dat snapshot_blob.bin v8_context_snapshot.bin vk_swiftshader_icd.json *.pak ${dyalogHome}
    cp lib/htmlrenderer.so ${dyalogHome}/lib
  ''
  + lib.optionalString sqaplSupport ''
    cp lib/cxdya65u64u.so ${dyalogHome}/lib
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

    for exec in "dyalog" "mapl"; do
        makeWrapper ${dyalogHome}/$exec $out/bin/$exec ${toString makeWrapperArgs}
    done

    install -Dm755 scriptbin/dyalogscript $out/bin/dyalogscript
    substituteInPlace $out/bin/dyalogscript \
        --subst-var-by installdir ${dyalogHome} \
        --subst-var-by scriptdir $out/bin

    runHook postInstall
  '';

  # Register some undeclared runtime dependencies to be patched in by autoPatchelfHook
  preFixup = ''
    patchelf ${dyalogHome}/dyalog --add-needed libncurses.so
  ''
  + lib.optionalString htmlRendererSupport ''
    patchelf ${dyalogHome}/libcef.so --add-needed libudev.so --add-needed libGL.so
  '';

  meta = {
    changelog = "https://dyalog.com/dyalog/dyalog-versions/${lib.replaceStrings [ "." ] [ "" ] finalAttrs.shortVersion}.htm";
    description = "The Dyalog APL interpreter";
    homepage = "https://www.dyalog.com";
    license = {
      fullName = "Dyalog License";
      url = licenseUrl;
      free = false;
    };
    mainProgram = "dyalog";
    maintainers = with lib.maintainers; [ tomasajt markus1189 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
