{
  stdenv,
  lib,
  fetchFromForgejo,
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
  version = "1.3.0";

  src = fetchFromForgejo {
    domain = "git.oss.uzinfocom.uz";
    owner = "xinux";
    repo = "e-imzo-manager";
    tag = finalAttrs.version;
    hash = "sha256-QXAfrNPaq76HALhUlMdSygbfA5wJI4rGHDpnwPI/74w";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-9yyTtMf1oCJWfFxWsaYWGT2/iTqU+3Ls0LIdHrNGZJI=";
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
    homepage = "https://git.oss.uzinfocom.uz/xinux/e-imzo-manager";
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
