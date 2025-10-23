{
  lib,
  cargo-tauri,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  libayatana-appindicator,
  nix-update-script,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "samira";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "jsnli";
    repo = "Samira";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SZg4N9fm4+p2vROCx7BLdphHeWlFkQrjQETObwPP8H0=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-l6lgJsrBtnxdWFJUhm2ftrRA8yBw47EY0QA4xNYhG6c=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-XSso9/eZPqv+k+0TBL9bRXWqi9PC5LPhga2zMmVDuUE=";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook

    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    libayatana-appindicator
    openssl
    webkitgtk_4_1
  ];

  preFixup = ''
    mkdir -p $out/share/lib
    cp $src/assets/libsteam_api.so $out/share/lib

    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/share/lib"
    )
  '';

  passthru.updateScript = nix-update-script;

  meta = {
    description = "Steam Achievement Manager for Linux";
    homepage = "https://github.com/jsnli/Samira";
    changelog = "https://github.com/jsnli/Samira/releases/tag/v${finalAttrs.version}";
    license = [
      lib.licenses.gpl3
      (
        # while the license itself is unfree, it allows redistributing files
        # inside "redistributable_bin/" directory, that `libsteam_api.so`
        # conveniently is inside that folder
        lib.licenses.unfreeRedistributableFirmware
        // {
          fullName = "Valve Corporation Steamworks SDK Access Agreement";
          shortName = "valveSDKLicense";
          url = "https://partner.steamgames.com/documentation/sdk_access_agreement";
        }
      )
    ];
    # the libsteam_api.so supports only x86_64-linux
    platforms = [ "x86_64-linux" ];
    mainProgram = "samira";
    maintainers = with lib.maintainers; [ perchun ];
  };
})
