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
  patchedPkgs =
    let
      baseURL = "https://github.com/Tunnelblick/Tunnelblick/raw/master/third_party/sources/openvpn";
    in
    appendOverlays [
      (final: prev: {
        # Nordvpn uses a patched openvpn in order to perform xor obfuscation
        # https://github.com/NordSecurity/nordvpn-linux/blob/e61430/ci/openvpn/check_dependencies.sh
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

  # libxml2 2.14.[0-4] breaks daemon
  libxml2' = libxml2.overrideAttrs (oldAttrs: {
    src = fetchurl {
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
      url = "mirror://gnome/sources/libxml2/2.13/libxml2-2.13.8.tar.xz";
    };
    meta = oldAttrs.meta // {
      knownVulnerabilities = oldAttrs.meta.knownVulnerabilities or [ ] ++ [
        "CVE-2025-6021"
      ];
    };
  });

in
buildGoModule (finalAttrs: {

  pname = "nordvpn";
  version = "3.20.3";

  src = fetchFromGitHub {
    hash = "sha256-iNXDH3vzsJGFFDIHRDA2F2n/v6sSpJK2CG3HzIzM8u4=";
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

  vendorHash = "sha256-NonkCcSDxLFoFo8XIxyMRO61GbC1fohVHiJH7stnQW8=";

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
      Additionally, if using firewall via `networking.firewall.enable = true;`,
      then should set `networking.firewall.checkReversePath` to either `"loose"` or `false`.
      Contributions are welcome!
    '';
    homepage = "https://github.com/nordsecurity/nordvpn-linux";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sanferdsouza ];
    platforms = lib.platforms.linux;
  };
})
