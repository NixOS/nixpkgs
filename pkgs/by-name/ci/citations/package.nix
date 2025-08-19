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
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "citations";
    rev = finalAttrs.version;
    hash = "sha256-aJp9UrfRXAsnHFGgMTHGRgCvlPEa62r9/0hEp5YKRzE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = finalAttrs.src;
    hash = "sha256-ZoflXdou6S7CYFF5x1pB71Ur08X1W6wPaJIm1sYsI2w=";
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

  meta = with lib; {
    description = "Manage your bibliographies using the BibTeX format";
    homepage = "https://apps.gnome.org/app/org.gnome.World.Citations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ benediktbroich ];
    teams = [ teams.gnome-circle ];
    platforms = platforms.unix;
    mainProgram = "citations";
  };
})
