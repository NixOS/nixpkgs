{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  rustPlatform,
  cargo,
  rustc,
  pkg-config,
  glib,
  libadwaita,
  libxml2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iconic";
  version = "2026.8.1";

  src = fetchFromGitHub {
    owner = "youpie";
    repo = "Iconic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q6AB3SNqodjRiv9EqjfNHE9MTP+LpnuxG7oyjF4Uzd8=";
  };

  postPatch = ''
    substituteInPlace src/windows/file_handling.rs \
      --replace-fail '"/app/share/Iconic/folders/"' '"$out/share/Iconic/folders/"'
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-l5UpqzgRcM5q7l14b5NAyLuY5QloAA20/0sYrEQA6QE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    blueprint-compiler
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
    pkg-config
  ];

  buildInputs = [
    glib
    libadwaita
    libxml2
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/youpie/Iconic";
    description = "Easily add images on top of folders";
    mainProgram = "folder_icon";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
