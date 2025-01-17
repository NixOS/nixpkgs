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
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${version}";
    hash = "sha256-sYid6erZlMskrw1BPu7JAs2mWn0JGcrnbZtuWPlD60U=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/apps/readest-app";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-YmuqMqO9AisSHv7iJK/ElQig/fF/+ngrqSzlvtnX2xc=";
  };

  pnpmRoot = "..";

  cargoHash = "sha256-EjTb7T86WeVCqZkUy6HLhW+R2a5H1lA//6ZkkqzqZwQ=";

  cargoRoot = "src-tauri";

  buildAndTestSubdir = cargoRoot;

  postPatch = ''
    substituteInPlace $cargoRoot/Cargo.toml \
      --replace-fail '"devtools"' '"devtools", "rustls-tls"'
    substituteInPlace $cargoRoot/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"Readest"' '"readest"'
    jq 'del(.plugins."deep-link")' $cargoRoot/tauri.conf.json | sponge $cargoRoot/tauri.conf.json
  '';

  preConfigure = ''
    chmod -R +w ../..
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
    mainProgram = "readest";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
