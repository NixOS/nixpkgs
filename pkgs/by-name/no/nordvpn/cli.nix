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
  libxslt,
  makeDesktopItem,
  makeWrapper,
  nftables,
  openvpn,
  procps,
  systemdMinimal,
  wireguard-tools,

  libtelio ? callPackage ./libtelio.nix { },
  libdrop ? callPackage ./libdrop.nix { },
  callPackage,
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

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libtelio
    libdrop
  ];

  # exposed for debugging/rebuilding either lib on its own (e.g. `nix build
  # .#nordvpn.cli.libtelio`), and so `nix-update` can bump them independently
  # when a new nordvpn-linux release needs newer versions of either.
  passthru = {
    inherit libtelio libdrop;
  };

  vendorHash = "sha256-vqNxPGcxGiEtBOGr+ZJHJNts/N4RMQzAL9DOjk13v/w=";

  env = {
    CGO_ENABLED = "1";
    # telio.h / norddrop.h are already vendored alongside the *.go files in
    # the libtelio-go / libdrop-go modules, so only -L/-l is needed here.
    CGO_LDFLAGS = "-L${libtelio}/lib -ltelio -L${libdrop}/lib -lnorddrop";
  };

  # telio/drop/cdnrc are all open-source, public build tags (see
  # .env.sample and ci/compile.sh in NordSecurity/nordvpn-linux).
  # `moose` and `quench` are the remaining tags and are proprietary/internal
  # only -- deliberately left out.
  #
  # cdnrc gates the *real* remote-config client (config/remote.CdnRemoteConfig).
  # Without it, cmd/daemon/no_cdnrc_cfg.go substitutes a stub whose
  # IsFeatureEnabled unconditionally returns false -- which silently disables
  # meshnet (and any other remote-config-gated feature) even though telio/drop
  # are otherwise fully linked in.
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

    # Meshnet peer hostnames are written straight to /etc/hosts (see
    # daemon/dns/hosts.go), which upstream treats as fatal to the whole
    # "enable meshnet" operation if it fails -- but /etc/hosts is normally
    # an immutable symlink into the Nix store. Make both directions
    # best-effort instead (this file already treats an identical
    # UnsetHosts failure elsewhere -- around the `netw.mesh.Disable()`
    # cleanup path -- as non-fatal; unSetMesh() just wasn't consistent
    # with that), so meshnet still works without needing to make any part
    # of /etc writable. Only local hostname resolution for peers is lost.
    #
    # Without also patching unSetMesh(), disabling meshnet leaves
    # networker.Combined.isMeshnetSet stuck at true (the early return
    # skips the line further down that resets it), so the next `nordvpn
    # set meshnet on` fails immediately with "meshnet already set".
    substituteInPlace networker/networker.go \
        --replace-fail \
            $'if err := netw.dnsHostSetter.SetHosts(hosts); err != nil {\n\t\treturn err\n\t}' \
            $'if err := netw.dnsHostSetter.SetHosts(hosts); err != nil {\n\t\tlog.Error(err)\n\t}' \
        --replace-fail \
            $'if err := netw.dnsHostSetter.UnsetHosts(); err != nil {\n\t\treturn fmt.Errorf("unsetting hosts: %w", err)\n\t}' \
            $'if err := netw.dnsHostSetter.UnsetHosts(); err != nil {\n\t\tlog.Error(err)\n\t}'
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

    export LD_LIBRARY_PATH=${
      lib.makeLibraryPath [
        libtelio
        libdrop
      ]
    }''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH

    go test -tags "telio drop cdnrc" ./cli
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
    # libtelio.so / libnorddrop.so are linked into all three binaries (not
    # just the daemon -- the cli and norduserd also import telio-gated
    # packages). `patchelf --add-rpath` corrupts these Go binaries (their
    # DYNAMIC segment ends up inside a read-only LOAD segment, so ld.so
    # segfaults writing DT_DEBUG at startup) -- use a wrapper's
    # LD_LIBRARY_PATH instead, which doesn't touch the ELF at all.
    nordvpnLibraryPath=${
      lib.makeLibraryPath [
        libtelio
        libdrop
      ]
    }

    wrapProgram $out/bin/nordvpn --prefix LD_LIBRARY_PATH : "$nordvpnLibraryPath"
    wrapProgram $out/bin/norduserd --prefix LD_LIBRARY_PATH : "$nordvpnLibraryPath"
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
