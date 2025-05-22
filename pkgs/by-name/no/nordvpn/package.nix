{
  appendOverlays,
  buildGoModule,
  copyDesktopItems,
  e2fsprogs,
  fetchFromGitHub,
  fetchurl,
  iproute2,
  iptables,
  lib,
  libxml2,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  procps,
  systemdMinimal,
  wireguard-tools,
}:
let
  patchedPkgs = appendOverlays [
    (final: prev: {
      # Nordvpn uses a patched openvpn in order to perform xor obfuscation
      # https://github.com/NordSecurity/nordvpn-linux/blob/e61430/ci/openvpn/check_dependencies.sh
      openvpn = prev.openvpn.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./openvpn-patches/02-tunnelblick-openvpn_xorpatch-a.diff
          ./openvpn-patches/03-tunnelblick-openvpn_xorpatch-b.diff
          ./openvpn-patches/04-tunnelblick-openvpn_xorpatch-c.diff
          ./openvpn-patches/05-tunnelblick-openvpn_xorpatch-d.diff
          ./openvpn-patches/06-tunnelblick-openvpn_xorpatch-e.diff
        ];

      });
    })
  ];

  # libxml2 2.14.[0-4] breaks daemon
  libxml2' = libxml2.overrideAttrs (oldAttrs: {
    src = fetchurl {
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
      url = "mirror://gnome/sources/libxml2/2.13/libxml2-2.13.8.tar.xz";
    };
  });

in
buildGoModule (finalAttrs: {

  pname = "nordvpn";
  version = "4.0.0";

  src = fetchFromGitHub {
    hash = "sha256-0GgMIFi6qrO7NG94vvWprwWr+8j87M5eH5W/pCtSWqs=";
    owner = "NordSecurity";
    repo = "nordvpn-linux";
    tag = finalAttrs.version;
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    # cgo build dependencies go here
    # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/go.section.md#envcgo_enabled-var-go-cgo_enabled
    libxml2'
  ];

  vendorHash = "sha256-GREoxjXqb28nabNvvcGjQA1rG4h9e/gINqEPY4++6Oo=";

  modPostBuild = ''
    patch -p0 < ${./gokogiri-xpath-expression.patch}
  '';

  preBuild = ''
    # use path $out/bin instead of /usr/lib
    sed -i "s|/usr/lib/nordvpn|$out/bin|" internal/constants.go

    # use path <<openvpnPatch>>/bin/openvpn instead of /usr/lib/nordvpn/openvpn
    old_ovpn_path='filepath.Join(internal.AppDataPathStatic, "openvpn")'
    new_ovpn_path=\"${patchedPkgs.openvpn}/bin/openvpn\"
    sed -i "s|$old_ovpn_path|$new_ovpn_path|" daemon/vpn/openvpn/config.go
  '';

  ldflags = [
    "-X main.Environment=prod"
    "-X main.Hash=${finalAttrs.version}"
    # changing the salt would result in nordvpnd crash for existing users
    "-X main.Salt=e91c1fee12f64ba7a12130a55d5d1d59"
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
    go test ./daemon -skip 'TestTransports|TestH1Transport_RoundTrip'
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
        iproute2
        iptables
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

  meta = {
    description = "NordVPN application for Linux.";
    longDescription = ''
      NordVPN application for Linux.
      This package currently does not support meshnet.
      Additionally, if enabling firewall via `networking.firewall.enable = true;`,
      then should also set `networking.firewall.checkReversePath = "loose";`.
      Contributions are welcome!
    '';
    homepage = "https://github.com/nordsecurity/nordvpn-linux";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sanferdsouza ];
    platforms = lib.platforms.linux;
  };
})
