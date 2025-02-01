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
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${version}";
    hash = "sha256-ZU1LmzeCeVVll6H4ySXqo5ljv9SrnF4iIqUejd2VB4U=";
    fetchSubmodules = true;
  };

  postUnpack = ''
    chmod -R +w .
  '';

  sourceRoot = "${src.name}/apps/readest-app";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-0QQnYPBCwxa8+YAP2MTZ8mN9gaKj5n9slb74NEGbbdE=";
  };

  pnpmRoot = "../..";

  useFetchCargoVendor = true;

  cargoHash = "sha256-IyzyjQJPf3gOj8PauT02rHVUIv4yJc207swpNzwgUcg=";

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
    maintainers = with lib.maintainers; [ nayeko ];
    platforms = lib.platforms.linux;
  };
}
