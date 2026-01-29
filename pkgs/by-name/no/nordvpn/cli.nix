{
  myDesktopItemArgs,
  myMeta,
  mySrc,
  myVersion,

  buildGoModule,
  copyDesktopItems,
  e2fsprogs,
  fetchFromGitHub,
  iproute2,
  iptables,
  lib,
  libxslt,
  makeDesktopItem,
  makeWrapper,
  openvpn,
  pkg-config,
  procps,
  systemdMinimal,
  wireguard-tools,
}:
let
  patchedOpenvpn = openvpn.overrideAttrs (old: {
    patches =
      let
        tunnelblickSrc = fetchFromGitHub {
          owner = "Tunnelblick";
          repo = "Tunnelblick";
          tag = "v8.0";
          hash = "sha256-Kj/F7hI6E+giT+4iGDUjXCLgy/6jcohtTWtLXOpZfo0=";
        };

        p = "third_party/sources/openvpn/openvpn-${old.version}/patches";
        name2urlFtn = fname: "${tunnelblickSrc}/${p}/${fname}";
      in
      (old.patches or [ ])
      ++ (lib.map name2urlFtn [
        "02-tunnelblick-openvpn_xorpatch-a.diff"
        "03-tunnelblick-openvpn_xorpatch-b.diff"
        "04-tunnelblick-openvpn_xorpatch-c.diff"
        "05-tunnelblick-openvpn_xorpatch-d.diff"
        "06-tunnelblick-openvpn_xorpatch-e.diff"
      ]);
  });

in
buildGoModule (finalAttrs: {
  pname = "nordvpn-cli";
  version = myVersion;

  src = mySrc;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pkg-config
  ];

  vendorHash = "sha256-outOvVAu76Pa9lQbiXQP2wA2cee3Ofq41SwfL6JEKs0=";

  preBuild = ''
    # use path $out/bin instead of /usr/lib
    substituteInPlace internal/constants.go \
        --replace-fail "/usr/lib/nordvpn" "$out/bin"

    # use path <<openvpnPatch>>/bin/openvpn
    old_ovpn_path='filepath.Join(internal.AppDataPathStatic, "openvpn")'
    new_ovpn_path='"${patchedOpenvpn}/bin/openvpn"'
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

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    go test ./cli
    # skip tests that require network access
    go test ./daemon -skip \
        'TestTransports|TestH1Transport_RoundTrip|Test.*FileList_RealURL'
    go test ./norduser

    runHook postCheck
  '';

  postInstall = ''
    # rename to standard names
    BIN_DIR=$out/bin
    install $BIN_DIR/cli $BIN_DIR/nordvpn
    install $BIN_DIR/daemon $BIN_DIR/nordvpnd
    install $BIN_DIR/norduser $BIN_DIR/norduserd
    rm $BIN_DIR/{cli,daemon,norduser}

    # nordvpn needs icons for the system tray and notifications
    ICONS_PATH=$out/share/icons/hicolor/scalable/apps
    install -d $ICONS_PATH
    install --mode=0444 assets/icon.svg $ICONS_PATH/nordvpn.svg
    for file in assets/*; do
        install --mode=0444 "$file" "$ICONS_PATH/nordvpn-$(basename $file)"
    done
  '';

  postFixup = ''
    wrapProgram $out/bin/nordvpnd --set PATH ${
      lib.makeBinPath [
        e2fsprogs
        iproute2
        iptables
        libxslt
        patchedOpenvpn
        procps
        systemdMinimal
        wireguard-tools
      ]
    }
  '';

  desktopItems = [
    (makeDesktopItem (
      myDesktopItemArgs
      // {
        comment = "I get called after NordVPN oauth browser login.";
        desktopName = "NordVPN CLI";
        exec = "nordvpn click %u";
        mimeTypes = [ "x-scheme-handler/nordvpn" ];
        name = "nordvpn";
        noDisplay = true;
        terminal = true;
      }
    ))
  ];

  meta = myMeta // {
    description = ''
      NordVPN cli application.
      Contains client and daemon.
      Even if you intend to use the gui only, you'd need this package.
    '';
    mainProgram = "nordvpn";
  };
})
