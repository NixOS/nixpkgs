{
  lib,
  stdenv,
  dpkg,
  fetchurl,
  libgcc,
  libnetfilter_conntrack,
  autoPatchelfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "speedify";
  # Find latest version within https://apt.connectify.me/dists/speedify/main/binary-amd64/Packages.gz
  version = "16.7.0-12928";

  src = fetchurl {
    url = "https://apt.connectify.me/pool/main/s/speedify/speedify_${finalAttrs.version}_amd64.deb";
    hash = "sha256-A77LYBGLAgoRFV64/ZmpTL76NQx6xHq0a7leDYi9Izg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    libgcc
    libnetfilter_conntrack
  ];

  installPhase = ''
    runHook preInstall

    substituteInPlace "usr/share/speedify/SpeedifyStartup.sh" "usr/share/speedify/SpeedifyShutdown.sh" "usr/share/speedify/GenerateLogs.sh" \
      --replace-fail '/usr/share/' "$out/share/"
    substituteInPlace "usr/share/speedify/SpeedifyStartup.sh" \
      --replace-fail 'logs' "/var/log/speedify"

    mkdir -p $out/share/
    mv usr/share $out/
    mkdir -p $out/etc/
    mv lib/systemd $out/etc/

    mkdir -p $out/bin
    ln -s $out/share/speedify/speedify_cli $out/bin/speedify_cli

    runHook postInstall
  '';

  meta = {
    homepage = "https://speedify.com/";
    description = "Use multiple internet connections in parallel";
    longDescription = ''
      Combine multiple internet connections (Wi-Fi, 4G, 5G, Ethernet, Starlink, Satellite, and more)
      to improve the stability, speed, and security of your online experiences.
      Check corresponding option {option}`services.speedify.enable`
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ zahrun ];
  };
})
