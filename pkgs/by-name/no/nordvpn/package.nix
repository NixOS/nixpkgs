{
  appendOverlays,
  autoPatchelfHook,
  buildGoModule,
  cacert,
  fetchFromGitHub,
  gcc,
  iproute2,
  iptables,
  lib,
  libidn2,
  libxml2,
  pkg-config,
  procps,
  sysctl,
  wireguard-tools,
  zlib,
}:
let
  patchedPkgs =
    let
      baseURL = "https://github.com/Tunnelblick/Tunnelblick/raw/master/third_party/sources/openvpn";
    in
    appendOverlays [
      (final: prev: {
        # Nordvpn uses a patched openvpn in order to perform xor obfuscation
        # See https://github.com/NordSecurity/nordvpn-linux/blob/e614303aaaf1a64fde5bb1b4de1a7863b22428c4/ci/openvpn/check_dependencies.sh
        openvpn = prev.openvpn.overrideAttrs (old: {
          patches =
            (old.patches or [ ])
            ++ (
              let
                patchURL = "${baseURL}/openvpn-2.6.14/patches";
              in
              [
                (prev.fetchpatch {
                  url = "${patchURL}/02-tunnelblick-openvpn_xorpatch-a.diff";
                  hash = "sha256-b9NiWETc0g2a7FNwrLaNrWx7gfCql7VTbewFu3QluFk=";
                })
                (prev.fetchpatch {
                  url = "${patchURL}/03-tunnelblick-openvpn_xorpatch-b.diff";
                  hash = "sha256-X/SshB/8ItLFBx6TPhjBwyA97ra0iM2KgsGqGIy2s9I=";
                })
                (prev.fetchpatch {
                  url = "${patchURL}/04-tunnelblick-openvpn_xorpatch-c.diff";
                  hash = "sha256-fw0CxJGIFEydIVRVouTlD1n275eQcbejUdhrU1JAx7g=";
                })
                (prev.fetchpatch {
                  url = "${patchURL}/05-tunnelblick-openvpn_xorpatch-d.diff";
                  hash = "sha256-NLRtoRVz+4hQcElyz4elCAv9l1vp4Yb3/VJef+L/FZo=";
                })
                (prev.fetchpatch {
                  url = "${patchURL}/06-tunnelblick-openvpn_xorpatch-e.diff";
                  hash = "sha256-mybdjCIT9b6ukbGWYvbr74fKtcncCtTvS5xSVf92T6Y=";
                })
              ]
            );
        });
      })
    ];
in
buildGoModule (finalAttrs: {

  pname = "nordvpn";
  version = "3.20.2";

  src = fetchFromGitHub {
    hash = "sha256-XB/wOdp97VnAkzHTHrJ2xffEx4HNFWn9yjFz3TsaEsE=";
    owner = "NordSecurity";
    repo = "nordvpn-linux";
    tag = finalAttrs.version;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    cacert
    gcc
    iproute2
    iptables
    libidn2
    libxml2
    procps
    sysctl
    zlib
  ];

  vendorHash = "sha256-gW/KieixLS6TTcBOHeYK9L8sieERrj6ia+iov8rT2AE=";

  preBuild = ''
    # use nixos path to <<nordvpnPkg>>/bin dir instead of /usr/lib
    sed -i "s|/usr/lib/nordvpn|$out/bin|g" internal/constants.go

    # use path to <<openvpnPatch>>/bin/openvpn instead of /usr/lib/nordvpn pkg
    old_ovpn_path='filepath.Join(internal.AppDataPathStatic, "openvpn")'
    new_ovpn_path=\"${patchedPkgs.openvpn}/bin/openvpn\"
    sed -i "s|$old_ovpn_path|$new_ovpn_path|" daemon/vpn/openvpn/config.go

    # Fix missing include in a library preventing compilation
    chmod +w vendor/github.com/jbowtie/gokogiri/xpath/
    sed -i '6i#include <stdlib.h>' vendor/github.com/jbowtie/gokogiri/xpath/expression.go
  '';

  ldflags = [
    "-X main.Environment=dev"
    "-X main.Hash=${finalAttrs.version}"
    "-X main.Salt=development"
    "-X main.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/cli"
    "cmd/norduser"
    "cmd/daemon"
  ];

  postInstall = ''
    # rename to standard names
    BIN_DIR=$out/bin
    install -m550 $BIN_DIR/cli $BIN_DIR/nordvpn
    install -m550 $BIN_DIR/daemon $BIN_DIR/nordvpnd
    install -m550 $BIN_DIR/norduser $BIN_DIR/norduserd
    rm $BIN_DIR/{cli,daemon,norduser}

    # Nordvpn needs icons for the system tray and notifications
    ASSETS_PATH=$out/share/icons/hicolor/scalable/apps
    install -Dm440 assets/icon.svg $ASSETS_PATH/nordvpn.svg
    nordvpn_asset_prefix="nordvpn-" # hardcoded image prefix
    for file in assets/*; do
      install -Dm440 "$file" "$ASSETS_PATH/''\${nordvpn_asset_prefix}$(basename "$file")"
    done
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    go test ./cli
    # tests require network access
    go test ./daemon -skip 'TestTransports|TestH1Transport_RoundTrip'
    go test ./norduser

    runHook postCheck
  '';

  meta = {
    description = "NordVPN CLI and daemon application for Linux";
    homepage = "https://github.com/nordsecurity/nordvpn-linux";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sanferdsouza ];
    platforms = lib.platforms.linux;
  };
})
