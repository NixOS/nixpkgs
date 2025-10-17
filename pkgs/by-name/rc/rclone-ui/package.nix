{
  lib,
  fetchFromGitHub,
  rustPlatform,

  cargo-tauri,
  nodejs,
  npmHooks,
  fetchNpmDeps,

  pkg-config,
  wrapGAppsHook3,

  openssl,
  webkitgtk_4_1,
  glib-networking,
  libappindicator,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rclone-ui";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "rclone-ui";
    repo = "rclone-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gwZXI501lE3Tm9M8k6a2NJCsvbiPB3Y4yhhr4gkpkY4=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    forceGitDeps = true;
    hash = "sha256-OkPVPT4JBbkVcfGtSs6oi+VFA3sxp1b6fVr68ILtnPU=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-8RK1rrGyxRNCTARlYUJNXWaH9F/3hV31uyNXjvWJaFU=";

  # Disable tauri bundle updater, can be removed when #389107 is merged
  patches = [ ./remove_updater.patch ];

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"mainBinaryName": "Rclone UI"' '"mainBinaryName": "${finalAttrs.pname}"'
    substituteInPlace src-tauri/Cargo.toml \
       --replace-fail 'name = "app"' 'name = "${finalAttrs.pname}"'
  '';

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs

    cargo-tauri.hook

    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
    glib-networking
    libappindicator
  ];

  dontWrapGApps = true;

  postInstall = ''
    wrapProgram $out/bin/rclone-ui \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libappindicator ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform desktop GUI for rclone & S3";
    homepage = "https://github.com/rclone-ui/rclone-ui";
    downloadPage = "https://github.com/rclone-ui/rclone-ui";
    changelog = "https://github.com/rclone-ui/rclone-ui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "rclone-ui";
  };
})
