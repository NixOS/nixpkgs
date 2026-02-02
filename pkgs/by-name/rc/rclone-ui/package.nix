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
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "rclone-ui";
    repo = "rclone-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GKOIS/kp1zfBu1/goH3zjQGrvs6opS4Sghpgc60xn0s=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    forceGitDeps = true;
    hash = "sha256-uvtYyAE68atl933dhgpwBipO01xecSCMKsrv9NdSEhk=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-1RxgcRM0Qs/bMj8mVLFZXD1Y8L+JZnc4BTmD5Y609Sk=";

  # Disable tauri bundle updater, can be removed when #389107 is merged
  patches = [ ./remove_updater.patch ];
  # Remove duplicate tao-macros dependency causing fetchCargoVendor failure.
  cargoPatches = [ ./remove_duplicate_dependency.patch ];

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
