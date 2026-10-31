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
  version = "0.5.6";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = "libipuz";
    rev = finalAttrs.version;
    hash = "sha256-5V4tbJuDgZ7HLXCnhYvFk2DnWa7ZGUr9WcthGwLjxmU=";
  };

  cargoRoot = "libipuz/rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      src
      version
      cargoRoot
      ;
    hash = "sha256-mkhjtgLt5lIuj32QmMcb5/TQZCai7mwLkXvTRcjO/+g=";
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
    gi-docgen
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
