{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron
, asar, alsa-lib, gtk3, libxshmfence, mesa, nss }:

stdenv.mkDerivation rec {
  pname = "morgen";
  version = "3.4.5";

  src = fetchurl {
    url = "https://dl.todesktop.com/210203cqcj00tw1/versions/${version}/linux/deb";
    hash = "sha256-5oBIw9PVbEGF1e47GeYNF6gJFm5z3M9KeJ1711cAg2s=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    asar
  ];

  buildInputs = [ alsa-lib gtk3 libxshmfence mesa nss ];

  unpackCmd = ''
    dpkg-deb -x ${src} ./morgen-${pname}
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out

    asar extract $out/opt/Morgen/resources/app.asar "$TMP/work"
    # 1. Fixes path for todesktop-runtime-config.json
    # 2. Fixes startup script
    substituteInPlace $TMP/work/dist/main.js \
      --replace "process.resourcesPath,\"todesktop-runtime-config.json" "\"$out/opt/Morgen/resources/todesktop-runtime-config.json" \
      --replace "Exec=\".concat(process.execPath," "Exec=\".concat(\"$out/bin/morgen\","
    asar pack --unpack='{*.node,*.ftz,rect-overlay}' "$TMP/work" $out/opt/Morgen/resources/app.asar

    substituteInPlace $out/share/applications/morgen.desktop \
      --replace '/opt/Morgen' $out/bin

    makeWrapper ${electron}/bin/electron $out/bin/morgen \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer}} $out/opt/Morgen/resources/app.asar"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "All-in-one Calendars, Tasks and Scheduler";
    homepage = "https://morgen.so/download";
    mainProgram = "morgen";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ justanotherariel wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
