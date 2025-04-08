{
  rustPlatform,
  pnpm_9,
  cargo-tauri,
  nodejs,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook3,
  fetchFromGitHub,
  gtk3,
  librsvg,
  openssl,
  autoPatchelfHook,
  lib,
  nix-update-script,
  moreutils,
  jq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "readest";
  version = "0.9.30";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kratl77JJzrwzc3hi+BCjT/E2qmmbeJeXxiGH0AcM9I=";
    fetchSubmodules = true;
  };

  postUnpack = ''
    # pnpm.configHook has to write to ../.., as our sourceRoot is set to apps/readest-app
    chmod -R +w .
  '';

  sourceRoot = "${finalAttrs.src.name}/apps/readest-app";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-6JFBw/jktEQBXum7Cb4TrntbrnVQM36jE6sby2bmIlw=";
  };

  pnpmRoot = "../..";

  useFetchCargoVendor = true;

  cargoHash = "sha256-2XYfcYjrg7RUXuI0B4i9DVNr0i0bYNYHj1peAi77QaE=";

  cargoRoot = "../..";

  buildAndTestSubdir = "src-tauri";

  postPatch = ''
    substituteInPlace src-tauri/Cargo.toml \
      --replace-fail '"devtools"' '"devtools", "rustls-tls"'
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"Readest"' '"readest"'
    jq 'del(.plugins."deep-link")' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    substituteInPlace src/services/constants.ts \
      --replace-fail "autoCheckUpdates: true" "autoCheckUpdates: false"
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpm_9.configHook
    pkg-config
    wrapGAppsHook3
    autoPatchelfHook
    moreutils
    jq
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    librsvg
    openssl
  ];

  preBuild = ''
    pnpm setup-pdfjs
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, feature-rich ebook reader";
    homepage = "https://github.com/readest/readest";
    changelog = "https://github.com/readest/readest/releases/tag/v${finalAttrs.version}";
    mainProgram = "readest";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ eljamm ];
    platforms = lib.platforms.linux;
  };
})
