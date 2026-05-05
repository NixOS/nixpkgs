{
  lib,
  pkg-config,
  rustPlatform,
  cargo-tauri,
  pnpmConfigHook,
  fetchPnpmDeps,
  pnpm_10, # used in upstream build toolchain
  nodejs_24, # used in upstream build toolchain
  faketty, # nx requires a TTY, see https://github.com/nrwl/nx/issues/22445
  perl,
  protobuf_29,
  webkitgtk_4_1,
  openssl,
  glib-networking,
  gst_all_1,
  postgresql,
  wrapGAppsHook3,
  fetchFromGitHub,

  embeddedDbOpts ? { },
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "retrom";
  version = "0.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JMBeresford";
    repo = "retrom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sXduy81+C9yy33yw2u/FEGOTkrok2LcjGn710/EzIFY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-MmWCpe7NzzT8W/Ic9y1VzGAp4rk0vxoOxbz5sRRlQs0=";
  };

  # Cargo.lock has git dependencies
  cargoHash = "sha256-13VHe4LU3R8NKhcDedhUcnnF9fQd95C3E+moh2jPnis=";

  buildAndTestSubdir = "packages/client";

  nativeBuildInputs = [
    pkg-config
    pnpmConfigHook
    pnpm_10
    nodejs_24
    faketty
    perl
    protobuf_29
    cargo-tauri.hook
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
    glib-networking
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  # Patch source to use system postgres install
  postPatch =
    let
      opts = lib.concatMapAttrsStringSep "&" (name: value: "${name}=${value}") (
        {
          installation_dir = postgresql;
          trust_installation_dir = "true";
          "configuration.unix_socket_directories" = "/tmp";
        }
        // embeddedDbOpts
      );
    in
    ''
      substituteInPlace plugins/retrom-plugin-standalone/src/desktop.rs \
        --replace-fail \
          "?data_dir={}&password_file={}" \
          "?data_dir={}&password_file={}&${opts}"
    '';

  preBuild = ''
    export CI=true
    export NX_NO_CLOUD=true
    export NX_DAEMON=false

    # See https://github.com/nrwl/nx/issues/22445
    faketty pnpm nx build:desktop retrom-client-web
  '';

  passthru.updateScript = {
    command = [ ./update.sh ];
    supportedFeatures = [ "commit" ];
  };

  meta = with lib; {
    description = "Desktop client for the Retrom game library management service";
    homepage = "https://github.com/JMBeresford/retrom";
    changelog = "https://github.com/JMBeresford/retrom/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      concurac
    ];
    # Upstream supports macOS and Windows but only Linux is tested in nixpkgs
    platforms = platforms.linux;
    mainProgram = "Retrom";
  };
})
