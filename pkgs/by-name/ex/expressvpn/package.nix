{
  autoPatchelfHook,
  brotli,
  dbus,
  fetchurl,
  fontconfig,
  freetype,
  glib,
  lib,
  libcap_ng,
  libdrm,
  libglvnd,
  libice,
  libnl,
  libsm,
  libxkbcommon,
  stdenv,
  wayland,
  zlib,
}:

let
  version = "14.2.1.13658";
in
stdenv.mkDerivation {
  pname = "expressvpn";
  inherit version;

  src = fetchurl {
    url = "https://www.expressvpn.works/clients/linux/expressvpn-linux-universal-${version}_release.run";
    hash = "sha256-o9y+sIwcZO7bkhsYwNkdZM3oS5eEQ336dMdmLzDsTDk=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    glib
    libxkbcommon
    fontconfig
    freetype
    libcap_ng
    dbus
    zlib
    brotli
    libglvnd
    libdrm
    wayland
    libsm
    libice
  ];

  # The daemon loads libnl dynamically for network-change monitoring.
  runtimeDependencies = [ (lib.getLib libnl) ];

  # The archive ships optional QML plugins whose backing Qt libraries are not
  # bundled. The client does not import these modules.
  autoPatchelfIgnoreMissingDeps = [
    "libQt6StateMachineQml.so.6"
    "libQt6StateMachine.so.6"
    "libQt6QmlXmlListModel.so.6"
    "libQt6LabsAnimation.so.6"
    "libQt6LabsFolderListModel.so.6"
    "libQt6LabsWavefrontMesh.so.6"
    "libQt6LabsSharedImage.so.6"
    "libQt6LabsSettings.so.6"
    "libQt6LabsQmlModels.so.6"
    "libQt6Bodymovin.so.6"
    "libQt6QuickTest.so.6"
    "libQt6Test.so.6"
    "libQt6QuickTimeline.so.6"
    "libQt6QuickParticles.so.6"
    "libQt6VirtualKeyboard.so.6"
    "libQt6QmlLocalStorage.so.6"
    "libQt6Sql.so.6"
    "libQt6WlShellIntegration.so.6"
    "libQt6EglFsKmsSupport.so.6"
    "libQt6EglFSDeviceIntegration.so.6"
  ];

  unpackPhase = ''
    runHook preUnpack
    bash "$src" --noexec --accept --target ./extract
    cd "./extract/${if stdenv.hostPlatform.isAarch64 then "arm64" else "x64"}"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"/{bin,libexec/expressvpn,lib,plugins,qml,share}
    cp -r expressvpnfiles/bin/* "$out/libexec/expressvpn/"
    cp -r expressvpnfiles/lib/* "$out/lib/"
    cp -r expressvpnfiles/plugins/* "$out/plugins/"
    cp -r expressvpnfiles/qml/* "$out/qml/"
    cp -r expressvpnfiles/share/* "$out/share/"

    install -Dm644 installfiles/app-icon.png "$out/share/pixmaps/expressvpn.png"
    install -Dm644 installfiles/expressvpn.desktop "$out/share/applications/expressvpn.desktop"

    substituteInPlace "$out/libexec/expressvpn/qt.conf" \
      --replace-fail /opt/expressvpn "$out"
    substituteInPlace "$out/libexec/expressvpn/openvpn-updown.sh" \
      --replace-fail /opt/expressvpn/var /var/lib/expressvpn

    ln -s expressvpn-daemon "$out/libexec/expressvpn/expressvpnd"
    ln -s expressvpnctl "$out/libexec/expressvpn/expressvpn"
    runHook postInstall
  '';

  postFixup = ''
    for name in expressvpn-daemon expressvpn-client expressvpnctl \
                expressvpn-support-tool support-tool-launcher browser_helper; do
      cat > "$out/bin/$name" <<EOF
    #!${stdenv.shell}
    exec /opt/expressvpn/bin/$name "\$@"
    EOF
      chmod +x "$out/bin/$name"
    done
    ln -s expressvpn-daemon "$out/bin/expressvpnd"
    ln -s expressvpnctl "$out/bin/expressvpn"
  '';

  meta = {
    description = "CLI and GUI clients for ExpressVPN";
    homepage = "https://www.expressvpn.com";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ yureien ];
    mainProgram = "expressvpn";
  };
}
