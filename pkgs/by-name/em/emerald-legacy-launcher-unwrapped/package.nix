{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pkg-config,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  wrapGAppsHook4,
  openssl,
  webkitgtk_4_1,
  glib-networking,
  libayatana-appindicator,
  librsvg,
  udev,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emerald-legacy-launcher-unwrapped";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "LCE-Hub";
    repo = "LCE-Emerald-Launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v1CuQwyh7vki+SKBwZwYGJmHy7HvY1P3cf/OrunjYJk=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-GfDuleIaeq6dpSzg4wWlClY2iYM5izbGv1febKuCh7I=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-nY2DHKanLq6oe/NeWEdCU160OJ9srofVN34S/pfDk9I=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pkg-config
    pnpmConfigHook
    pnpm
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libayatana-appindicator
    librsvg
    udev
    webkitgtk_4_1
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace "$cargoDepsCopy"/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" \
      "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  preBuild = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"beforeBuildCommand": "npm run build"' '"beforeBuildCommand": "pnpm run build"' \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libayatana-appindicator
          udev
        ]
      }
    )
  '';

  meta = {
    homepage = "https://github.com/LCE-Hub/LCE-Emerald-Launcher";
    description = "FOSS cross-platform launcher for Minecraft Legacy Console Edition";
    longDescription = ''
      LCE Emerald Launcher is the easiest way to play Minecraft Legacy Console Edition on PC. Install community builds, manage versions, customize skins, and launch instantly from one lightweight hub.
      Why Emerald? Traditional launchers often rely on bloated frameworks, consuming excessive resources. Emerald utilizes a modern Tauri architecture, using only a low amount of RAM, leaving your PC's resources dedicated to the game itself.
    '';
    changelog = "https://github.com/LCE-Hub/LCE-Emerald-Launcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "emerald-legacy-launcher";
    maintainers = with lib.maintainers; [ sopyb ];
    # It should work on nix-darwin, but I can't check nor mantain
    platforms = lib.platforms.linux;
  };
})
