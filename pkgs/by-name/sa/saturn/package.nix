{
  lib,
  applyPatches,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nodejs,
  lld,
  pkg-config,
  wasm-pack,
  wasm-bindgen-cli_0_2_118,
  binaryen,
  copyDesktopItems,
  makeDesktopItem,
  glib,
  gtk3,
  webkitgtk_4_1,
}:
let
  isLinux = stdenv.isLinux;
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "saturn";
  version = "0-unstable-2025-10-02";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "1whatleytay";
      repo = "saturn";
      rev = "db965b6646a73d71ef37b3c401c741f82032d338";
      hash = "sha256-6RAOdbJqh3LFy10su1mtzRrMBSPpwNMPZpYiH/WP32o=";
    };
    patches = [ ./workspace.patch ];
  };

  cargoHash = "sha256-+IIZt21nq9ZyrEZO4V0T+jKukdZQ9DOTCFw4OqWrKkQ=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-MHIhh7trXCCwMr4B/BEmf1JPn85+/T4WgO3mDmaY/hM=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpmConfigHook
    pnpm
    nodejs
    lld
    pkg-config
    wasm-bindgen-cli_0_2_118
    binaryen
  ]
  ++ (lib.optional isLinux copyDesktopItems);

  buildInputs = [
    glib.dev
    gtk3.dev
    webkitgtk_4_1.dev
  ];

  postPatch = ''
    substituteInPlace package.json \
      --replace "wasm-pack build" "${lib.getExe wasm-pack} build"
  '';

  desktopItems = lib.optional isLinux (makeDesktopItem {
    name = "saturn";
    desktopName = "Saturn";
    comment = "Modern MIPS interpreter and assembler";
    icon = "saturn";
    exec = "saturn";
    terminal = false;
    # TODO: startupWMClass
  });

  # TODO: darwin .app
  postInstall =
    lib.optionalString isLinux
      # sh
      ''
        install -Dm644 $src/src-tauri/icons/32x32.png $out/share/icons/hicolor/32x32/apps/saturn.png
        install -Dm644 $src/src-tauri/icons/128x128.png $out/share/icons/hicolor/128x128/apps/saturn.png
        install -Dm644 $src/src-tauri/icons/128x128@2x.png $out/share/icons/hicolor/256x256/apps/saturn.png
        install -Dm644 $src/src-tauri/icons/icon.png $out/share/icons/hicolor/512x512/apps/saturn.png
      '';

  meta = with lib; {
    description = "Modern MIPS interpreter and assembler";
    homepage = "https://github.com/1whatleytay/saturn";
    license = licenses.mit;
    maintainers = [ maintainers.justdeeevin ];
    mainProgram = "saturn";
    platforms = platforms.all;
  };
})
