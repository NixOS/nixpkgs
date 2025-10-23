{
  lib,
  rustPlatform,
  fetchFromGitHub,

  cargo-tauri,
  jq,
  moreutils,
  nodejs,
  pkg-config,
  pnpm_9,

  libayatana-appindicator,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "overlayed";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "overlayeddev";
    repo = "overlayed";
    tag = "v${version}";
    hash = "sha256-3GFg8czBf1csojXUNC51xFXJnGuXltP6D46fCt6q24I=";
  };

  cargoRoot = "apps/desktop/src-tauri";
  buildAndTestSubdir = "apps/desktop/src-tauri";

  cargoHash = "sha256-6wN4nZQWrY0J5E+auj17B3iJ/84hzBXYA/bJsX/N5pk=";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    fetcherVersion = 1;
    hash = "sha256-+yyxoodcDfqJ2pkosd6sMk77/71RDsGthedo1Oigwto=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pkg-config
    pnpm_9.configHook
  ];

  buildInputs = [
    libayatana-appindicator
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    # disable updater
    jq '.plugins.updater.endpoints = [ ] | .bundle.createUpdaterArtifacts = false' \
      apps/desktop/src-tauri/tauri.conf.json | sponge apps/desktop/src-tauri/tauri.conf.json
  '';

  meta = {
    description = "Modern discord voice chat overlay";
    homepage = "https://github.com/overlayeddev/overlayed";
    changelog = "https://github.com/overlayeddev/overlayed/releases/tag/v${version}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.agpl3Plus;
    mainProgram = "overlayed";
  };
}
