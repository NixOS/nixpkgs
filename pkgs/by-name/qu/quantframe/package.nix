{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri_1,
  nodejs,
  pnpm_9,
  pkg-config,
  glib-networking,
  openssl,
  webkitgtk_4_0,
  wrapGAppsHook3,
  libsoup_2_4,
  libayatana-appindicator,
  gtk3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "quantframe";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "Kenya-DK";
    repo = "quantframe-react";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/cjlYQHb23DY4RSjc2HosTar6p1epsqlWQX6TlrzSe8=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  patches = [
    ./0001-disable-telemetry.patch
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-4uyjvwvrMDe+86wcB7MBBWWc4NGKzqBsgG3TScf7BMk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mtHbWTNrWh4hq4IAncE9TCWr7sozIy2zf3DK3WN7wqI=";

  nativeBuildInputs = [
    cargo-tauri_1.hook

    pkg-config
    wrapGAppsHook3

    nodejs
    pnpm_9.configHook
  ];

  buildInputs = [
    openssl
    libsoup_2_4
    glib-networking
    gtk3
    libayatana-appindicator
    webkitgtk_4_0
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  meta = {
    description = "Warframe Market listings and transactions manager";
    mainProgram = "quantframe";
    homepage = "https://quantframe.app/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nyukuru ];
  };
})
