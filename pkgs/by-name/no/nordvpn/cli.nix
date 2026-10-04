{
  desktopItemArgs,
  meta,
  src,
  version,

  buildGoModule,
  copyDesktopItems,
  e2fsprogs,
  fetchFromGitHub,
  iproute2,
  lib,
  libdrop,
  libtelio,
  libxslt,
  makeDesktopItem,
  makeWrapper,
  nftables,
  openvpn,
  procps,
  sqlite,
  systemdMinimal,
  wireguard-tools,
}:
let
  patchedOpenvpn = openvpn.overrideAttrs (old: {
    # Apply XOR obfuscation patches to disguise OpenVPN traffic,
    # enabling connectivity on networks that block VPN protocols via DPI.
    patches =
      let
        tunnelblickSrc = fetchFromGitHub {
          owner = "Tunnelblick";
          repo = "Tunnelblick";
          # https://github.com/NordSecurity/nordvpn-linux/blob/4.6.0/ci/openvpn/env.sh#L11
          tag = "v6.0beta09";
          hash = "sha256-uLYrBgwX3HkEV06snlIYLsgfhD5lNDVR21D56ygoStY=";
        };

        pathDir = "third_party/sources/openvpn/openvpn-2.6.12/patches";
      in
      (old.patches or [ ])
      ++ (map (fname: "${tunnelblickSrc}/${pathDir}/${fname}") [
        "02-tunnelblick-openvpn_xorpatch-a.diff"
        "03-tunnelblick-openvpn_xorpatch-b.diff"
        "04-tunnelblick-openvpn_xorpatch-c.diff"
        "05-tunnelblick-openvpn_xorpatch-d.diff"
        "06-tunnelblick-openvpn_xorpatch-e.diff"
      ]);
  });

in
buildGoModule (finalAttrs: {
  inherit src version;

  pname = "nordvpn-cli";

  # adds a --hosts-readonly flag that makes nordvpn never touch /etc/hosts
  patches = [ ./hosts-readonly.patch ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libtelio
    libdrop
    sqlite
  ];

  vendorHash = "sha256-vqNxPGcxGiEtBOGr+ZJHJNts/N4RMQzAL9DOjk13v/w=";

  env = {
    CGO_ENABLED = "1";
    CGO_LDFLAGS = "-L${libtelio}/lib -ltelio -L${libdrop}/lib -lnorddrop";
  };

  # `moose` and `quench` are the remaining tags and are proprietary/internal only
  tags = [
    "telio"
    "drop"
    "cdnrc"
  ];

  preBuild = ''
    # redirect AppDataPathStatic (/usr/lib/nordvpn) to $out/bin so that
    # NorduserdBinaryPath resolves to $out/bin/norduserd.
    substituteInPlace internal/constants.go \
        --replace-fail "/usr/lib/nordvpn" "$out/bin"

    # hardcode the openvpn path to the patched one
    old_ovpn_path='filepath.Join(internal.AppDataPathStatic, "openvpn")'
    new_ovpn_path='"${patchedOpenvpn}/bin/openvpn"'
    substituteInPlace daemon/vpn/openvpn/config.go \
        --replace-fail "$old_ovpn_path" "$new_ovpn_path"
  '';

  ldflags = [
    "-X main.Environment=prod"
    "-X main.Version=${finalAttrs.version}"
    # matches upstream's default from .env.sample
    "-X main.RemotePath=/apps/linux/config"
  ];

  subPackages = [
    "cmd/cli"
    "cmd/daemon"
    "cmd/fileshare"
    "cmd/norduser"
  ];

  checkPhase = ''
    runHook preCheck

    export LD_LIBRARY_PATH=${
      lib.makeLibraryPath [
        libtelio
        libdrop
      ]
    }''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH

    go test -tags "telio drop cdnrc" ./cli
    go test -tags "telio drop cdnrc" ./fileshare/...
    # skip tests that require network access
    go test -tags "telio drop cdnrc" ./daemon -skip \
        'TestTransports|TestH1Transport_RoundTrip|Test.*FileList_RealURL'
    go test -tags "telio drop cdnrc" ./norduser

    runHook postCheck
  '';

  postInstall = ''
    # rename to standard names
    BIN_DIR=$out/bin
    mv $BIN_DIR/cli $BIN_DIR/nordvpn
    mv $BIN_DIR/daemon $BIN_DIR/nordvpnd
    mv $BIN_DIR/fileshare $BIN_DIR/nordfileshare
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
    # `patchelf --add-rpath` corrupts these Go binaries (DYNAMIC segment ends
    # up inside a read-only LOAD segment, ld.so segfaults writing DT_DEBUG at
    # startup) -- use a wrapper's LD_LIBRARY_PATH instead.
    nordvpnLibraryPath=${
      lib.makeLibraryPath [
        libtelio
        libdrop
      ]
    }

    for f in $out/bin/{nordvpn,norduserd,nordfileshare}; do
      wrapProgram $f --prefix LD_LIBRARY_PATH : "$nordvpnLibraryPath"
    done

    wrapProgram $out/bin/nordvpnd \
      --prefix LD_LIBRARY_PATH : "$nordvpnLibraryPath" \
      --prefix PATH : ${
        lib.makeBinPath [
          e2fsprogs
          iproute2
          libxslt # xsltproc: used to populate OpenVPN configuration files from templates
          nftables
          patchedOpenvpn
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
