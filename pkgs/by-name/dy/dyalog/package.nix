{ lib
, stdenv
, fetchFromGitHub
, fetchurl

, config
, acceptLicense ? config.dyalog.acceptLicense or false

, autoPatchelfHook
, dpkg
, makeWrapper

, copyDesktopItems
, makeDesktopItem

, glib
, ncurses5

, dotnet-sdk_6
, dotnetSupport ? false

, alsa-lib
, gtk2
, libXdamage
, libXtst
, libXScrnSaver
, nss
, htmlRendererSupport ? false

, R
, rPackages
, rSupport ? false

, unixODBC
, sqaplSupport ? false

, zeroFootprintRideSupport ? false

, enableDocs ? false
}:

let
  dyalogHome = "$out/lib/dyalog";

  rscproxy = rPackages.buildRPackage {
    name = "rscproxy";
    src = fetchFromGitHub {
      owner = "Dyalog";
      repo = "rscproxy";
      rev = "31de3323fb8596ff5ecbf4bacd030e542cfd8133";
      hash = "sha256-SVoBoAWUmQ+jWaTG7hdmyRq6By4RnmmgWZXoua19/Kg=";
    };
  };

  makeWrapperArgs = [
    "--set DYALOG ${dyalogHome}"
    # also needs to be set when the `-script` flag is used
    "--add-flags DYALOG=${dyalogHome}"
    # needed for default user commands to work
    "--add-flags SESSION_FILE=${dyalogHome}/default.dse"
  ]
  ++ lib.optionals dotnetSupport [
    # needs to be set to run .NET Bridge
    "--set DOTNET_ROOT ${dotnet-sdk_6}"
    # .NET Bridge files are runtime dependencies, but cannot be patchelf'd
    "--prefix LD_LIBRARY_PATH : ${dyalogHome}"
  ]
  ++ lib.optionals rSupport [
    # RConnect resolves R from PATH
    "--prefix PATH : ${R}/bin"
    # RConnect uses `ldd` to find `libR.so`
    "--prefix LD_LIBRARY_PATH : ${R}/lib/R/lib"
    # RConnect uses `rscproxy` to communicate with R
    "--prefix R_LIBS_SITE : ${rscproxy}/library"
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dyalog";
  version = "18.2.45405";
  shortVersion = lib.versions.majorMinor finalAttrs.version;

  src =
    assert !acceptLicense -> throw licenseDisclaimer;
    fetchurl {
      url = "https://download.dyalog.com/download.php?file=${finalAttrs.shortVersion}/linux_64_${finalAttrs.version}_unicode.x86_64.deb";
      sha256 = "sha256-pA/WGTA6YvwG4MgqbiPBLKSKPtLGQM7BzK6Bmyz5pmM=";
    };

  outputs = [ "out" ] ++ lib.optional enableDocs "doc";

  postUnpack = ''
    sourceRoot=$sourceRoot/opt/mdyalog/${finalAttrs.shortVersion}/64/unicode
  '';

  patches = [ ./dyalogscript.patch ./mapl.patch ];

  postPatch = lib.optionalString dotnetSupport ''
    # Patch to use .NET 6.0 instead of .NET Core 3.1 (can be removed when Dyalog 19.0 releases)
    substituteInPlace Dyalog.Net.Bridge.*.json --replace "3.1" "6.0"
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    makeWrapper
  ];

  buildInputs = [
    glib # Used by Conga and .NET Bridge
    ncurses5 # Used by the dyalog binary
  ]
  ++ lib.optionals htmlRendererSupport [
    alsa-lib
    gtk2
    libXdamage
    libXtst
    libXScrnSaver
    nss
  ]
  ++ lib.optionals sqaplSupport [
    unixODBC
  ];

  # See which files are not really important: `https://github.com/Dyalog/DyalogDocker/blob/master/rmfiles.sh`
  installPhase = ''
    runHook preInstall

    mkdir -p ${dyalogHome}
    cp -r aplfmt aplkeys apltrans fonts Library PublicCACerts SALT StartupSession ${dyalogHome}
    cp aplkeys.sh default.dse dyalog dyalog.rt dyalog.dcfg.template dyalog.ver.dcfg.template languagebar.json mapl startup.dyalog ${dyalogHome}

    mkdir ${dyalogHome}/lib
    cp lib/{conga34_64.so,dyalog64.so,libconga34ssl64.so} ${dyalogHome}/lib

    # Only keep the most useful workspaces
    mkdir ${dyalogHome}/ws
    cp ws/{conga,dfns,isolate,loaddata,salt,sharpplot,util}.dws ${dyalogHome}/ws
  ''
  + lib.optionalString dotnetSupport ''
    cp libnethost.so Dyalog.Net.Bridge.* ${dyalogHome}
  ''
  + lib.optionalString htmlRendererSupport ''
    cp -r locales swiftshader ${dyalogHome}
    cp libcef.so libEGL.so libGLESv2.so chrome-sandbox natives_blob.bin snapshot_blob.bin icudtl.dat v8_context_snapshot.bin *.pak ${dyalogHome}
    cp lib/htmlrenderer.so ${dyalogHome}/lib
  ''
  + lib.optionalString rSupport ''
    cp ws/rconnect.dws ${dyalogHome}/ws
  ''
  + lib.optionalString sqaplSupport ''
    cp lib/cxdya64u64u.so ${dyalogHome}/lib
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
    install -Dm644 dyalog.svg $out/share/icons/hicolor/scalable/apps/dyalog.svg

    makeWrapper ${dyalogHome}/dyalog $out/bin/dyalog ${lib.concatStringsSep " " makeWrapperArgs}
    makeWrapper ${dyalogHome}/mapl $out/bin/mapl ${lib.concatStringsSep " " makeWrapperArgs}

    install -Dm755 scriptbin/dyalogscript $out/bin/dyalogscript
    substituteInPlace $out/bin/dyalogscript \
        --subst-var-by installdir ${dyalogHome} \
        --subst-var-by scriptdir $out/bin

    runHook postInstall
  '';

  preFixup = lib.optionalString htmlRendererSupport ''
    # `libudev.so` is a runtime dependency of CEF
    patchelf ${dyalogHome}/libcef.so --add-needed libudev.so
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "dyalog";
      desktopName = "Dyalog";
      exec = finalAttrs.meta.mainProgram;
      comment = finalAttrs.meta.description;
      icon = "dyalog";
      categories = [ "Development" ];
      genericName = "APL interpreter";
      terminal = true;
    })
  ];

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
