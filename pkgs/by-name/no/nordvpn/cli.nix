{
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
  tunnelblickSrc = fetchFromGitHub {
    owner = "Tunnelblick";
    repo = "Tunnelblick";
    tag = "v8.0";
    hash = "sha256-Kj/F7hI6E+giT+4iGDUjXCLgy/6jcohtTWtLXOpZfo0=";
  };

  patchedOpenvpn = openvpn.overrideAttrs (old: {
    patches =
      (old.patches or [ ])
      ++ (lib.map
        (fname: "${tunnelblickSrc}/third_party/sources/openvpn/openvpn-${old.version}/patches/${fname}")
        [
          "02-tunnelblick-openvpn_xorpatch-a.diff"
          "03-tunnelblick-openvpn_xorpatch-b.diff"
          "04-tunnelblick-openvpn_xorpatch-c.diff"
          "05-tunnelblick-openvpn_xorpatch-d.diff"
          "06-tunnelblick-openvpn_xorpatch-e.diff"
        ]
      );
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
        --replace-fail /usr/lib/nordvpn "$out/bin"

    # use path <<openvpnPatch>>/bin/openvpn
    old_ovpn_path='filepath.Join(internal.AppDataPathStatic, "openvpn")'
    new_ovpn_path=\"${patchedOpenvpn}/bin/openvpn\"
    substituteInPlace daemon/vpn/openvpn/config.go \
        --replace-fail "$old_ovpn_path" "$new_ovpn_path"
  '';

  ldflags = [
    "-X main.Environment=prod"
    "-X main.Hash=${finalAttrs.version}"
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
    ASSETS_PATH=$out/share/icons/hicolor/scalable/apps
    install -D assets/icon.svg $ASSETS_PATH/nordvpn.svg
    for file in assets/*; do
      install "$file" "$ASSETS_PATH/nordvpn-$(basename $file)"
    done
  '';

  postFixup = ''
    wrapProgram $out/bin/nordvpnd --set PATH ${
      lib.makeBinPath [
        e2fsprogs
        libxslt
        iproute2
        iptables
        patchedOpenvpn
        procps
        systemdMinimal
        wireguard-tools
      ]
    }
  '';

  desktopItems = [
    (makeDesktopItem {
      categories = [ "Network" ];
      comment = finalAttrs.meta.description;
      desktopName = "nordvpn";
      exec = "nordvpn click %u";
      icon = "nordvpn";
      mimeTypes = [ "x-scheme-handler/nordvpn" ];
      name = "nordvpn";
      terminal = true;
      type = "Application";
    })
  ];

  meta = myMeta // {
    description = "NordVPN cli application for Linux";
  };
})
