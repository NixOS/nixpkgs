{
  rustPlatform,
  lib,
  callPackage,
  pkg-config,
  openssl,
  libsoup_3,
  webkitgtk_4_1,
  fetchFromGitHub,
  libayatana-appindicator,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "overlayed";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "overlayeddev";
    repo = "overlayed";
    rev = "refs/tags/v${version}";
    hash = "sha256-3GFg8czBf1csojXUNC51xFXJnGuXltP6D46fCt6q24I=";
  };

  sourceRoot = "${src.name}/apps/desktop/src-tauri";

  webui = callPackage ./webui.nix {
    inherit meta src version;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
    libsoup_3
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "system-notification-0.1.0" = "sha256-T9SnKBy4x0Y5Ul6oECHJ/lvsYS2TPY8Nrg1R9JtJUXs=";
      "tauri-nspanel-2.0.0-beta" = "sha256-PhMkSrmmc6fJ0GmT9lPwYMsyBap7/g8vIp210l2nFU4=";
      "tauri-plugin-window-state-2.0.0-rc.1" = "sha256-8GR9q1+eiULDOtWlLy+sLylOzfAOUO5Q61EP/XvP6c0=";
    };
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    substituteInPlace ./tauri.conf.json \
      --replace-fail '../dist' '${webui}' \
      --replace-fail 'pnpm build' ' '
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
