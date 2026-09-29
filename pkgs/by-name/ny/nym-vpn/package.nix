{
  lib,
  stdenv,
  rustPlatform,
  buildGo127Module,
  fetchFromGitHub,
  fetchNpmDeps,
  symlinkJoin,
  wrapGAppsHook3,
  glib-networking,
  pciutils,
  xdg-utils,
  cargo-tauri,
  nodejs_24,
  npmHooks,
  pkg-config,
  protobuf,
  desktop-file-utils,
  dbus,
  glib,
  gtk3,
  libayatana-appindicator,
  libmnl,
  libnftnl,
  openssl,
  webkitgtk_4_1,
  libsoup_3,
}:

let
  version = "2026.12.4";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym-vpn-client";
    tag = "nym-vpn-v${version}";
    hash = "sha256-4zjoQRJ/IEdNoBf75B71XPDE3Kvih0lC8KiG6m7exP0=";
  };

  app = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "nym-vpn-app";
    inherit version src;

    cargoRoot = "nym-vpn-app/src-tauri";
    buildAndTestSubdir = finalAttrs.cargoRoot;

    cargoHash = "sha256-wJy6zF8SDPGP/jutCXivlNF80ML6i9R1ny0rW95dWi8=";

    npmRoot = "nym-vpn-app";

    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) src;
      sourceRoot = "${finalAttrs.src.name}/nym-vpn-app";
      hash = "sha256-59MY02gMKhIulxjck5woQjvCz0s0yJHlODwIq/IYr/k=";
    };

    postPatch = ''
      buildScript="$(echo "$cargoDepsCopy"/source-git-*/nym-network-defaults-1.21.4/build.rs)"
      test -f "$buildScript"

      cat > "$buildScript" <<'EOF'
      fn main() {}
      EOF
    '';

    nativeBuildInputs = [
      cargo-tauri.hook
      nodejs_24
      npmHooks.npmConfigHook
      pkg-config
      protobuf
      desktop-file-utils
    ];

    buildInputs = [
      dbus
      glib
      gtk3
      libayatana-appindicator
      libmnl
      libnftnl
      openssl
      webkitgtk_4_1
      libsoup_3
    ];

    # WEBKIT_DISABLE_DMABUF_RENDERER fixes blank window on nvidia/Wayland.
    # GIO_EXTRA_MODULES is required for TLS in webkit.
    preFixup = ''
      gappsWrapperArgs+=(
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
        --prefix PATH : "${
          lib.makeBinPath [
            pciutils
            desktop-file-utils
            xdg-utils
          ]
        }"
      )
    '';

    env = {
      UPDATER_ENABLED = "false";
      DEV_MODE = "false";
    };
  });

  core = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "nym-vpn-core";
    inherit version src;

    cargoRoot = "nym-vpn-core";
    buildAndTestSubdir = finalAttrs.cargoRoot;

    cargoHash = "sha256-CTz0OZlQYoA7J+ZzOJEj+ZV5dKpjH+C7fMgyNiKEGkY=";

    cargoBuildFlags = [
      "--package"
      "nym-vpnd"
      "--package"
      "nym-vpnc"
      "--package"
      "nym-socks5-proxy"
      "--package"
      "nym-diagnostic"
    ];

    postPatch = ''
      buildScript="$(echo "$cargoDepsCopy"/source-git-*/nym-network-defaults-1.21.4/build.rs)"
      test -f "$buildScript"

      cat > "$buildScript" <<'EOF'
      fn main() {}
      EOF
    '';

    preBuild = ''
      export BUILD_TOP="$PWD"

      install -Dm644 ${wireguardGo}/lib/libwg.a \
        "$BUILD_TOP/build/lib/${stdenv.hostPlatform.config}/libwg.a"
    '';

    # The Polkit file is needed for the "Authentication" and "Login" button to work and enable authentication with the Nym account
    # Polkit also needs to be enabled in the user configuration or possible nixos-module
    postInstall = ''
      install -d $out/share/polkit-1/actions

      cat > $out/share/polkit-1/actions/com.nymvpn.vpnd.unix-access.policy <<'EOF'
      <?xml version="1.0" encoding="UTF-8"?>
      <policyconfig>
        <action id="com.nymvpn.vpnd.unix-access">
          <description>Connect via unix socket</description>
          <message>Authentication is required to connect to the daemon</message>

          <defaults>
            <allow_any>auth_admin</allow_any>
            <allow_inactive>auth_admin</allow_inactive>
            <allow_active>auth_self</allow_active>
          </defaults>
        </action>
      </policyconfig>
      EOF
    '';

    nativeBuildInputs = [
      pkg-config
      protobuf
    ];

    buildInputs = [
      dbus
      libmnl
      libnftnl
      openssl
    ];
  });

  wireguardGo = buildGo127Module {
    pname = "nym-vpn-libwg";
    inherit version src;

    modRoot = "wireguard/libwg";

    vendorHash = "sha256-RzgfszOXjOXVwswH7o1qY6p7BgAEveV/loaSpUR/M38=";

    buildPhase = ''
      runHook preBuild

      go build \
        -v \
        -ldflags="-buildid=" \
        -trimpath \
        -buildvcs=false \
        -o libwg.a \
        -buildmode=c-archive \
        .

      runHook postBuild
    '';

    # Upstream release CI only builds the archive here.
    doCheck = false;

    installPhase = ''
      runHook preInstall

      install -Dm644 libwg.a $out/lib/libwg.a
      install -Dm644 libwg.h $out/include/libwg.h

      runHook postInstall
    '';
  };

in
symlinkJoin {
  name = "nym-vpn-${version}";

  strictDeps = true;
  __structuredAttrs = true;

  paths = [
    app
    core
  ];

  passthru = {
    inherit app core;
  };

  meta = {
    description = "NymVPN desktop application, daemon, and command-line tools";
    homepage = "https://nym.com/";
    license = lib.licenses.gpl3Only;
    mainProgram = "nym-vpn-app";
    platforms = lib.platforms.linux;
  };
}
