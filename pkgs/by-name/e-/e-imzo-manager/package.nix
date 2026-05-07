{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  desktop-file-utils,
  gnome-desktop,
  meson,
  ninja,
  pkg-config,
  polkit,
  rustc,
  rustPlatform,
  wrapGAppsHook4,
  gdk-pixbuf,
  glib,
  adwaita-icon-theme,
  gtk4,
  libadwaita,
  openssl,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "e-imzo-manager";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "xinux-org";
    repo = "e-imzo-manager";
    tag = finalAttrs.version;
    hash = "sha256-LX13zdwjlV99NziEP7PoJH8yxPV1gVQQH/L0VkuRLD4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-qnwAJ0gRzIxEkkDeNqiYMB+Dvth4MugUIe9sv7c46/E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gnome-desktop
    adwaita-icon-theme
    gtk4
    libadwaita
    openssl
    rustPlatform.bindgenHook
    polkit
  ];

  propagatedUserEnvPkgs = [ polkit ];

  postInstall = ''
    gappsWrapperArgs+=(
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs}
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/xinux-org/e-imzo-manager";
    mainProgram = "E-IMZO-Manager";
    description = "GTK application for managing E-IMZO keys";
    license = with lib.licenses; [ agpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      orzklv
      shakhzodkudratov
      bahrom04
      bemeritus
    ];
  };
})
