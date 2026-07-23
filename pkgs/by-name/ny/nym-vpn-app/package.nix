{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  stdenv,
  pkg-config,
  protobuf,
  nodejs,
  npmHooks,
  wrapGAppsHook3,
  makeWrapper,
  openssl,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  librsvg,
  glib-networking,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "nym-vpn-app";
  version = "1.29.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym-vpn-client";
    tag = "nym-vpn-app-v${version}";
    hash = "sha256-ZBcFC4ng/0NJvI6C/fbc7Oo2lOeiFFLpzrIUV1UNz+4=";
  };

  # The Rust workspace is one level down. cargoRoot is relative to sourceRoot
  # (which defaults to the unpacked source).
  cargoRoot = "nym-vpn-app/src-tauri";
  buildAndTestSubdir = cargoRoot;

  # Vendor npm dependencies for the frontend.
  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    sourceRoot = "${src.name}/nym-vpn-app";
    hash = "sha256-6itLxZprZTL0LyB51CIjOLLRQYKEmjQY1SKxY4Nf/DQ=";
  };
  npmRoot = "nym-vpn-app";

  # Cargo.lock contains two git dependencies that need explicit hashes.
  cargoLock = {
    lockFile = ./Cargo.lock;
    # Will be filled after first build failure.
    outputHashes = {
      "nym-crypto-1.20.4" = "sha256-aZTwjQ5zRxMNH7yPeNIVZK7JARwKAojYDRHWIcLRRH0=";
      "nym-pemstore-1.20.4" = "sha256-aZTwjQ5zRxMNH7yPeNIVZK7JARwKAojYDRHWIcLRRH0=";
    };
  };

  nativeBuildInputs = [
    protobuf
    pkg-config
    nodejs
    npmHooks.npmConfigHook
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
    gtk3
    libsoup_3
    librsvg
    glib-networking
    dbus
  ];

  # Build the frontend before cargo builds the Tauri Rust binary.
  # Tauri picks up the resulting dist/ via beforeBuildCommand in tauri.conf.json,
  # but in the Nix sandbox we run it explicitly to keep build phases predictable.
  preBuild = ''
    pushd nym-vpn-app
    npm run build
    popd
  '';

  # build_info_build embeds build/git info; without a .git dir it falls back
  # gracefully, but suppressing the warnings helps.
  env = {
    BUILD_INFO_DEFAULT_RUSTC_VERSION = "1";
    PROTOC = "${protobuf}/bin/protoc";
  };

  # Install the binary, desktop entry, and icons. Tauri's bundler is disabled
  # upstream (bundle.active=false), so we do this manually.
  postInstall = ''
    # Desktop entry
    install -Dm644 /dev/stdin $out/share/applications/nym-vpn.desktop <<DESKTOP
    [Desktop Entry]
    Type=Application
    Name=NymVPN
    Comment=Decentralized mixnet-hardened VPN client
    Exec=env LOG_FILE=1 RUST_LOG=info,nym_vpn_app=debug nym-vpn-app
    Icon=nym-vpn
    Terminal=false
    Categories=Network;VPN;
    StartupWMClass=nym-vpn-app
    DESKTOP

    # Icons (multiple sizes provided upstream)
    for size in 32 128; do
      install -Dm644 \
        nym-vpn-app/src-tauri/icons/''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/nym-vpn.png
    done
    install -Dm644 \
      nym-vpn-app/src-tauri/icons/128x128@2x.png \
      $out/share/icons/hicolor/256x256/apps/nym-vpn.png
  '';

  # WEBKIT_DISABLE_DMABUF_RENDERER fixes blank window on nvidia/Wayland.
  # GIO_EXTRA_MODULES is required for TLS in webkit.
  preFixup = ''
    gappsWrapperArgs+=(
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
    )
  '';

  # Tests would require network and a running nym-vpnd.
  doCheck = false;

  meta = {
    description = "Tauri-based desktop client for the NymVPN mixnet";
    longDescription = ''
      NymVPN is a decentralized, mixnet-hardened, privacy-focused VPN. This
      package provides the desktop GUI client (nym-vpn-app), which communicates
      with the nym-vpnd daemon via gRPC. nym-vpnd must be installed and running
      separately.
    '';
    homepage = "https://nymvpn.com/";
    changelog = "https://github.com/nymtech/nym-vpn-client/releases/tag/nym-vpn-app-v${version}";
    license = with lib.licenses; [
      gpl3Only
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ rachyandco ];
    mainProgram = "nym-vpn-app";
    platforms = lib.platforms.linux;
  };
}
