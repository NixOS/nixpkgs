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
    tag = "v${version}";
    hash = "sha256-3GFg8czBf1csojXUNC51xFXJnGuXltP6D46fCt6q24I=";
  };

  sourceRoot = "${src.name}/apps/desktop/src-tauri";

  useFetchCargoVendor = true;
  cargoHash = "sha256-6wN4nZQWrY0J5E+auj17B3iJ/84hzBXYA/bJsX/N5pk=";

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
