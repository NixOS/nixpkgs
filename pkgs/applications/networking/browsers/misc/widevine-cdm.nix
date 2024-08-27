{ lib
, stdenv
, fetchurl
, fetchzip
, fetchFromGitHub
, squashfsTools
, curl
, python3
}:

stdenv.mkDerivation rec {
  pname = "widevine-cdm";
  version = "4.10.2710.0";
  lacrosVersion = "120.0.6098.0";

  widevineInstaller = if stdenv.isAarch64 then fetchFromGitHub {
      owner = "AsahiLinux";
      repo = "widevine-installer";
      rev = "7a3928fe1342fb07d96f61c2b094e3287588958b";
      sha256 = "sha256-XI1y4pVNpXS+jqFs0KyVMrxcULOJ5rADsgvwfLF6e0Y=";
    } else null;

  src = if stdenv.isAarch64 then fetchurl {
    url = "https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/chromeos-lacros-arm64-squash-zstd-${lacrosVersion}";
    hash = "sha256-OKV8w5da9oZ1oSGbADVPCIkP9Y0MVLaQ3PXS3ZBLFXY=";
  } else fetchzip {
    url = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";
    hash = "sha256-lGTrSzUk5FluH1o4E/9atLIabEpco3C3gZw+y6H6LJo=";
    stripRoot = false;
  };

  buildInputs = [ squashfsTools curl python3 ];

  unpackPhase = if stdenv.isAarch64 then ''
    curl -# -o lacros.squashfs "file://$src"
    unsquashfs -q lacros.squashfs 'WidevineCdm/*'
    python3 ${widevineInstaller}/widevine_fixup.py squashfs-root/WidevineCdm/_platform_specific/cros_arm64/libwidevinecdm.so libwidevinecdm.so
    cp squashfs-root/WidevineCdm/manifest.json .
    cp squashfs-root/WidevineCdm/LICENSE LICENSE.txt
  '' else null;

  installPhase = ''
    runHook preInstall

    install -vD manifest.json $out/share/google/chrome/WidevineCdm/manifest.json
    install -vD LICENSE.txt $out/share/google/chrome/WidevineCdm/LICENSE.txt
    install -vD libwidevinecdm.so $out/share/google/chrome/WidevineCdm/_platform_specific/linux_${
    if stdenv.targetPlatform.isAarch64 then "arm64"
    else if stdenv.targetPlatform.isx86_64 then "x64"
    else throw "Unsupported platform ${stdenv.targetPlatform.config}"
    }/libwidevinecdm.so

    runHook postInstall
  '';

# Accoring to widevine-installer: "Hack because Chromium hardcodes a check for this right now..."
  postInstall = lib.optionalString stdenv.isAarch64 ''
    mkdir -p "$out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64"
    touch "$out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"
  '';

  meta = with lib; {
    description = "Widevine CDM";
    homepage = "https://www.widevine.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jlamur dxwil ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
