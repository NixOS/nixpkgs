{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  libcap_ng,
  libnsl,
  stdenv,
  libxkbcommon,
  libglvnd,
  qt6,
  systemd,
  openresolv,
}:

stdenvNoCC.mkDerivation {
  pname = "piavpn";
  version = "3.8.0-08539";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://installers.privateinternetaccess.com/download/pia-linux-3.8-08539.run";
    hash = "sha256-o88uK1DSlpO6WPCuIy5SxXhfAkSlbm7QBbaEsYdnOZ8=";
  };

  dontUnpack = true;

  dontWrapQtApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  preFixup = ''
    addAutoPatchelfSearchPath \
      ${libxkbcommon}/lib \
      ${libglvnd}/lib \
      ${qt6.qtsvg}/lib \
      ${qt6.qtvirtualkeyboard}/lib
  '';

  buildInputs = [
    libcap_ng
    libnsl
    stdenv.cc.cc.lib
    libxkbcommon
    libglvnd
    qt6.qtsvg
    qt6.qtvirtualkeyboard
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt/piavpn" "$out/bin"

    sh "$src" \
      --noexec \
      --keep \
      --nochown \
      --target "$TMPDIR/pia-extract"

    cp -a "$TMPDIR/pia-extract/piafiles/." "$out/opt/piavpn/"

    substituteInPlace "$out/opt/piavpn/bin/openvpn-updown.sh" \
      --replace-fail "/usr/bin/busctl" "${systemd}/bin/busctl"

    substituteInPlace "$out/opt/piavpn/bin/openvpn-updown.sh" \
      --replace-fail 'echo "Applying nameservers by overwriting resolv.conf..."' \
      'dns_error "No supported NixOS DNS integration is configured"'

    substituteInPlace "$out/opt/piavpn/bin/openvpn-updown.sh" \
      --replace-fail \
        'elif [ $(realpath /etc/resolv.conf) = $resolvconf_link_path ] && hash resolvconf 2> /dev/null; then' \
        'elif hash resolvconf 2> /dev/null; then'

    substituteInPlace "$out/opt/piavpn/bin/openvpn-updown.sh" \
      --replace-fail \
        'elif  [ $(realpath /etc/resolv.conf) = $resolvconf_link_path ] && hash resolvconf 2>/dev/null; then' \
        'elif hash resolvconf 2>/dev/null; then'

      sed -i '/^for (( i=1 ; ; i++ )); do$/i export PATH="${openresolv}/bin:$PATH"' \
        "$out/opt/piavpn/bin/openvpn-updown.sh"

    rm -rf \
      "$out/opt/piavpn/qml/QtQml/StateMachine" \
      "$out/opt/piavpn/qml/Qt/labs/lottieqt" \
      "$out/opt/piavpn/qml/QtQuick/Timeline" \
      "$out/opt/piavpn/qml/QtQuick/Scene3D" \
      "$out/opt/piavpn/qml/QtQuick/Scene2D"

    for program in pia-client pia-daemon piactl pia-support-tool; do
      if [ -x "$out/opt/piavpn/bin/$program" ]; then
        ln -s "$out/opt/piavpn/bin/$program" "$out/bin/$program"
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Private Internet Access VPN client";
    homepage = "https://www.privateinternetaccess.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      mikecm
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "piactl";
  };
}
