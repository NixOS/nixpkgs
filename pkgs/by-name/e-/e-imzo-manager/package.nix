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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "xinux-org";
    repo = "e-imzo";
    tag = finalAttrs.version;
    hash = "sha256-JXALTSgxIULDHdw90RjxlNQiLT+GKrzpkqPlMY0h+8c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-x9V0FHrSpM1pIWjDjcTuhPz4p0blXxKDJVvT0I0Op9M=";
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
    homepage = "https://github.com/xinux-org/e-imzo";
    mainProgram = "E-IMZO-Manager";
    description = "GTK application for managing E-IMZO keys";
    license = with lib.licenses; [ agpl3Plus ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.uzinfocom ];
  };
})
