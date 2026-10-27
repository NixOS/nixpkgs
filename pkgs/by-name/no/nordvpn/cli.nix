{
  desktopItemArgs,
  meta,
  src,
  version,

  buildGoModule,
  copyDesktopItems,
  e2fsprogs,
  iproute2,
  lib,
  libxslt,
  makeDesktopItem,
  makeWrapper,
  nftables,
  openvpn,
  procps,
  systemdMinimal,
  wireguard-tools,
}:
buildGoModule (finalAttrs: {
  inherit src version;

  pname = "nordvpn-cli";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  vendorHash = "sha256-dqKpsik9/wlWiJLJaB5bo6cBhkJFT1n6KDfsHq4YGx0=";

  preBuild = ''
    # redirect AppDataPathStatic (/usr/lib/nordvpn) to $out/bin so that
    # NorduserdBinaryPath resolves to $out/bin/norduserd.
    substituteInPlace internal/constants.go \
        --replace-fail "/usr/lib/nordvpn" "$out/bin"

    # hardcode the openvpn path
    old_ovpn_path='filepath.Join(internal.AppDataPathStatic, "openvpn")'
    new_ovpn_path='"${openvpn}/bin/openvpn"'
    substituteInPlace daemon/vpn/openvpn/config.go \
        --replace-fail "$old_ovpn_path" "$new_ovpn_path"
  '';

  ldflags = [
    "-X main.Environment=prod"
    "-X main.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/cli"
    "cmd/daemon"
    "cmd/norduser"
  ];

  checkPhase = ''
    runHook preCheck

    go test ./cli/...
    go test ./fileshare/...
    go test ./norduser/...

    # skip tests requiring network access, root/CAP_NET_ADMIN,
    # or network state the sandbox doesn't provide
    # skip libtelio tests as the package lacks meshnet support
    go test $(go list ./daemon/... | grep -v /daemon/vpn/nordlynx/libtelio) -skip \
      'Test.*FileList_RealURL|'\
      'TestAddAllowlistRules|'\
      'TestAddDevice|'\
      'TestConnectionInfo_TransferRatesShallBeProvidedOnlyForConnectedState|'\
      'TestCustomTable|'\
      'TestDiscoverNameserverIp|'\
      'TestFwmarkRule|'\
      'TestH1Transport_RoundTrip|'\
      'TestMeshnetRuleset|'\
      'TestMultiFwmarkRule|'\
      'TestNetlinkManager_SetUnset|'\
      'TestRouter_Add|'\
      'TestSetMTU|'\
      'TestSuppressRule|'\
      'TestTransports|'\
      'TestUpWGInterface|'\
      'TestVPNRuleset'

    runHook postCheck
  '';

  postInstall = ''
    # rename to standard names
    BIN_DIR=$out/bin
    mv $BIN_DIR/cli $BIN_DIR/nordvpn
    mv $BIN_DIR/daemon $BIN_DIR/nordvpnd
    mv $BIN_DIR/norduser $BIN_DIR/norduserd

    # nordvpn needs icons for the system tray and notifications
    ICONS_PATH=$out/share/icons/hicolor/scalable/apps
    install -d $ICONS_PATH
    install --mode=0444 assets/icon.svg $ICONS_PATH/nordvpn.svg
    for file in assets/tray-*.svg; do
        install --mode=0444 "$file" "$ICONS_PATH/nordvpn-$(basename $file)"
    done
  '';

  postFixup = ''
    wrapProgram $out/bin/nordvpnd --prefix PATH : ${
      lib.makeBinPath [
        e2fsprogs
        iproute2
        libxslt # xsltproc: used to populate OpenVPN configuration files from templates
        nftables
        openvpn
        procps
        systemdMinimal
        wireguard-tools
      ]
    }
  '';

  desktopItems = [
    (makeDesktopItem (
      desktopItemArgs
      // {
        comment = "Handles NordVPN OAuth browser login callbacks.";
        desktopName = "NordVPN CLI";
        exec = "nordvpn click %u";
        mimeTypes = [ "x-scheme-handler/nordvpn" ];
        name = "nordvpn";
        noDisplay = true;
        terminal = true;
      }
    ))
  ];

  meta = meta // {
    description = "NordVPN command-line client and daemon";
    longDescription = ''
      Contains the nordvpn client and nordvpnd daemon.
      Even if you intend to use the GUI only, you'd need this package.
    '';
    mainProgram = "nordvpn";
  };
})
