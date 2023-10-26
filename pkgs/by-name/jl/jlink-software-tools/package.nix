{ acceptLicense ? false
, lib
, stdenvNoCC
, requireFile
, fetchurl
, autoPatchelfHook
, patchelf
, dpkg
, xorg
, fontconfig
, libudev0-shim
}:

let
  meta = {
    homepage = "https://www.segger.com/downloads/jlink/";
    description = "Segger JLink Software and Documentation pack";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = [
      {
        shortName = "segger-sfl";
        fullName = "SEGGER's Friendly License";
        url = "https://www.segger.com/purchase/licensing/license-sfl/";
        free = false;
        redistributable = false;
        deprecated = false;

      }
      {
        shortName = "segger-cul";
        fullName = "SEGGER's Commercial-use License";
        url = "https://www.segger.com/purchase/licensing/license-cul/";
        free = false;
        redistributable = false;
        deprecated = false;
      }
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ liarokapisv ];
  };

  version = "V7.92k";
  versionNoDots = lib.strings.replaceStrings [ "." ] [ "" ] version;

  platformSpecific = {
    x86_64-linux = {
      fileName = "JLink_Linux_${versionNoDots}_x86_64.deb";
      sha256 = "sha256-MTPG0HeAcwOTHEHtqR/uOjuEu13UrTxQyX6zvwrDAoA=";
    };
  };

  src =
    let
      system = stdenvNoCC.hostPlatform.system;
      fileName = platformSpecific.${system}.fileName;
      sha256 = platformSpecific.${system}.sha256;
      url = " https://www.segger.com/downloads/jlink/${fileName}";
    in
    if acceptLicense then
      (fetchurl {
        inherit sha256;
        inherit url;
        curlOpts = "-d accept_license_agreement=accepted";
      }) else
      (requireFile {
        name = fileName;
        inherit sha256;
        inherit url;
      });
in
stdenvNoCC.mkDerivation
{
  pname = "jlink-software-tools";

  inherit version;
  inherit src;
  inherit meta;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    patchelf
  ];

  buildInputs = [
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcursor
    xorg.libX11
    xorg.libSM
    xorg.libICE
    fontconfig.lib
  ];

  desktopApps = [
    "JFlash"
    "JFlashLite"
    "JFlashSPI"
    "JLinkConfig"
    "JLink"
    "JLinkGDBServer"
    "JLinkGUIServer"
    "JLinkLicenseManager"
    "JLinkRegistration"
    "JLinkRemoteServer"
    "JLinkRTTClient"
    "JLinkRTTLogger"
    "JLinkRTTViewer"
    "JLinkSTM32"
    "JLinkSWOViewer"
    "JMem"
    "JRun"
    "JTAGLoad"
  ];

  installPhase = ''
    dpkg-deb -x $src $out

    # Soothe nix-build suspicions
    chmod -R g-w $out

    # Remove and recreate symlinks
    rm -R $out/usr
    mkdir -p $out/bin
    for path in $out/opt/SEGGER/JLink_${versionNoDots}/J*
    do
      name=$(basename "$path")
      ln -s "$out/opt/SEGGER/JLink_${versionNoDots}/$name" "$out/bin/$name"
    done

    # Add desktop entries icon
    mkdir -p $out/share/pixmaps
    ln -s ${./JLink.svg} $out/share/pixmaps/JLink.svg

    # Create desktop entries
    mkdir -p $out/share/applications
    for name in $desktopApps
    do
        cat << EOF > "$out/share/applications/$name.desktop"
    [Desktop Entry]
    Type=Application
    Name=$name
    Exec=''${name}Exe
    Icon=JLink
    Terminal=false
    StartupNotify=false
    Categories=Development
    EOF
        chmod +x "$out/share/applications/$name.desktop"
    done
  '';

  postFixup = ''
    # needed due to dlopen
    patchelf --add-rpath "${libudev0-shim}/lib" $out/opt/SEGGER/JLink_${versionNoDots}/libjlinkarm.so
  '';
}
