{
  lib,
  stdenv,
  cargo,
  fetchFromGitLab,
  gi-docgen,
  gobject-introspection,
  json-glib,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libipuz";
  version = "0.5.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = "libipuz";
    rev = finalAttrs.version;
    hash = "sha256-si+cc129oXLzD1o1MFcaxieIw8vPzWP8dbAnd4inF0Y=";
  };

  cargoRoot = "libipuz/rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      src
      version
      cargoRoot
      ;
    hash = "sha256-NbK++me/tOrl0MyxvyTIK9UWyR0jU3pkJ6c5sNjuY2M=";
  };

  nativeBuildInputs = [
    cargo
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    json-glib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for parsing .ipuz puzzle files";
    homepage = "https://gitlab.gnome.org/jrb/libipuz";
    changelog = "https://gitlab.gnome.org/jrb/libipuz/-/blob/${finalAttrs.version}/NEWS.md?ref_type=tags";
    license = with lib.licenses; [
      lgpl21Plus
      mit
    ];
    maintainers = with lib.maintainers; [
      aleksana
      l0b0
    ];
    platforms = lib.platforms.unix;
  };
})
