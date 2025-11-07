{
  lib,
  stdenv,
  cargo,
  fetchFromGitLab,
  gi-docgen,
  glib,
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
  version = "0.5.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = "libipuz";
    rev = finalAttrs.version;
    hash = "sha256-8bFMtqRD90SF9uT39Wkjf0eUef+0HgyrqY+DFA/xutI=";
  };

  cargoRoot = "libipuz/rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      src
      version
      cargoRoot
      ;
    hash = "sha256-Aw/caE5Z5JxoKLEr2Dr2wq6cyFleNNwtKM1yXM8ZWmU=";
  };

  nativeBuildInputs = [
    cargo
    gi-docgen
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    glib
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
