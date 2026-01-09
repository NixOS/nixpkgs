{
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  gettext,
  glib,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  poppler,
  rustPlatform,
  rustc,
  stdenv,
  testers,
  wrapGAppsHook4,
  clippy,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "citations";
  version = "0.9.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "citations";
    rev = finalAttrs.version;
    hash = "sha256-oWRBJvf7EimxIwdsr11vsN5605nZ4p4LQ1tzx/ZiCrg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = finalAttrs.src;
    hash = "sha256-FCrrZ9efzTsYleOzaBVjLpC+shgwLnvHfpJmWXF80DI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    gtksourceview5
    libadwaita
    poppler
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang (
    lib.concatStringsSep " " [
      "-Wno-typedef-redefinition"
      "-Wno-unused-parameter"
      "-Wno-missing-field-initializers"
      "-Wno-incompatible-function-pointer-types"
    ]
  );

  doCheck = true;

  nativeCheckInputs = [ clippy ];

  preCheck = ''
    sed -i -e '/PATH=/d' ../src/meson.build
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "citations --help";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Manage your bibliographies using the BibTeX format";
    homepage = "https://apps.gnome.org/app/org.gnome.World.Citations";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benediktbroich ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.unix;
    mainProgram = "citations";
  };
})
