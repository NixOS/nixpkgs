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

rustPlatform.buildRustPackage rec {
  pname = "readest";
  version = "0.9.23";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${version}";
    hash = "sha256-MveWZ+9SSd6mPw580U8d8aP7c4rl4861VzCKHpOKiXU=";
    fetchSubmodules = true;
  };

  postUnpack = ''
    # pnpm.configHook has to write to ../.., as our sourceRoot is set to apps/readest-app
    chmod -R +w .
  '';

  sourceRoot = "${src.name}/apps/readest-app";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-faLytJLMlWs80HZpN0TnCCEWPe9SPP9QH0bx3HLDO5o=";
  };

  pnpmRoot = "../..";

  useFetchCargoVendor = true;

  cargoHash = "sha256-5E+3Hpa6hiOORtZ5ykrXVOPucbppwO5KVVS1mb9mVXY=";

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
    changelog = "https://github.com/readest/readest/releases/tag/v${version}";
    mainProgram = "readest";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
