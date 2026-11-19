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
  cacert,

  aws-lc,
  openssl,
  webkitgtk_4_1,
  glib-networking,
  libappindicator,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rclone-ui";
  version = "3.7.7";

  src = fetchFromGitHub {
    owner = "rclone";
    repo = "rclone-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a/SM6mMTrfOJm13A+TJQ7CkB+48GmK+k0nIiohyHlUs=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    forceGitDeps = true;
    hash = "sha256-/Cto3uKKmcBG8H39HpqThWnMbGMgDgLQ6wswEQTwc/8=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-C6Ule6iDoPRtHpx+MYX0Flg8SHOOrOlTQfcKUXHR32E=";

  # Disable tauri bundle updater, can be removed when #389107 is merged
  patches = [ ./remove_updater.patch ];

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"mainBinaryName": "Rclone UI"' '"mainBinaryName": "${finalAttrs.meta.mainProgram}"'
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
    aws-lc
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

  # reqwest cannot build its client without a CA bundle:                                                                                                                             │
  # "No CA certificates were loaded from the system"                                                                                                                                 │
  nativeCheckInputs = [ cacert ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform desktop GUI for rclone & S3";
    homepage = "https://github.com/rclone/rclone-ui";
    downloadPage = "https://github.com/rclone/rclone-ui";
    changelog = "https://github.com/rclone/rclone-ui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "rclone-ui";
  };
})
