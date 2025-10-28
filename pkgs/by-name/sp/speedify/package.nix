{
  lib,
  stdenv,
  dpkg,
  fetchurl,
  procps,
  net-tools,
  autoPatchelfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "speedify";
  version = "15.8.2-12611";

  src = fetchurl {
    url = "https://apt.connectify.me/pool/main/s/speedify/speedify_${finalAttrs.version}_amd64.deb";
    hash = "sha256-61GQZkXBe3EQpOUODpL60SCHJO0FGqvpL9xFn+q+kPs=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    procps
    net-tools
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
