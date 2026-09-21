{
  fetchurl,
  lib,
  makeWrapper,
  dpkg,
  binutils,
  stdenv,
  installShellFiles,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "marvisclient-linux-unwrapped";
  version = "1.0.1";

  src = fetchurl {
    url = "https://mobile.mist.com/installers/marvisclient/linux_debian_x86/${finalAttrs.version}/marvisclient-installer.deb";
    hash = "sha256-/KBH9D6fAUjW62k4SpOA5sVNxgo07yH23+fsXIxSrQ0=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    binutils
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    # binaries
     installBin usr/bin/marvisclient-linux

     # desktop
     install -Dm 444 "usr/share/applications/Marvis Client.desktop" "$out/share/applications/Marvis Client.desktop"

     # icons
    for size in 32 128; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      install -Dm644 usr/share/icons/hicolor/''${size}x''${size}/apps/marvisclient-linux.png $out/share/icons/hicolor/''${size}x''${size}/apps/marvisclient-linux.png
     done

     runHook postInstall
  '';

  meta = {
    description = "Secure, lightweight application that simplifies connecting Linux devices to the enterprise network";
    homepage = "https://www.juniper.net/documentation/us/en/software/mist/mist-aiops/topics/topic-map/marvis-client-linux.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      jadewilk
    ];
    mainProgram = "marvisclient-linux";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
