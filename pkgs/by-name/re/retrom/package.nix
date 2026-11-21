{
  lib,
  pkg-config,
  rustPlatform,
  cargo-tauri,
  pnpmConfigHook,
  fetchPnpmDeps,
  pnpm_10,
  nodejs_24,
  faketty,
  perl,
  protobuf_29,
  webkitgtk_4_1,
  openssl,
  glib-networking,
  gst_all_1,
  postgresql_17,
  wrapGAppsHook3,
  fetchFromGitHub,
  nix-update-script,

  embeddedDbOpts ? { },
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "retrom";
  version = "0.8.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "JMBeresford";
    repo = "retrom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R2Ls9KFRqcRv6HYDWoK5otPx/8K9O+T5xLpA8RnwkDg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-5FkJc/rtptg4ZWlf1NU/57Ga8cLbW1LVc4MLxs+iyrA=";
  };

  cargoHash = "sha256-SxA3e5mts2WMjkXuIwsyvUKM6YK0W50vi17GL++LZQY=";

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

  env = {
    CI = "true";
    NX_NO_CLOUD = "true";
    NX_DAEMON = "false";
    OPENSSL_NO_VENDOR = "1";
  };

  # Patch source to use system postgres install
  postPatch =
    let
      opts = lib.concatMapAttrsStringSep "&" (name: value: "${name}=${value}") (
        {
          installation_dir = postgresql_17;
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
      substituteInPlace packages/client/tauri.conf.json \
        --replace-fail '"https://github.com/JMBeresford/retrom/releases/latest/download/latest.json"' ""
    '';

  preBuild = ''
    # See https://github.com/nrwl/nx/issues/22445
    faketty pnpm nx build:desktop retrom-client-web
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop client for the Retrom game library management service";
    homepage = "https://github.com/JMBeresford/retrom";
    changelog = "https://github.com/JMBeresford/retrom/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      concurac
    ];
    # Upstream supports macOS and Windows but only Linux has so far been tested
    platforms = lib.platforms.linux;
    mainProgram = "Retrom";
  };
})
