{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  gst_all_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kana";
  version = "1.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "fkinoshita";
    repo = "Kana";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/Ri723ub8LMlhbPObC83bay63JuWIQpgxAT5UUYuwZI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "kana-${finalAttrs.version}";
    hash = "sha256-3ODkAstBZQE3eqGmRUdm3xyCoBXV41hK4ndxeDK8+Yc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-plugins-good
  ]);

  # Workaround for the gettext-sys issue
  # https://github.com/Koka/gettext-rs/issues/114
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16"
  ) "-Wno-error=incompatible-function-pointer-types";

  meta = {
    description = "Learn Japanese hiragana and katakana characters";
    homepage = "https://gitlab.gnome.org/fkinoshita/kana";
    license = lib.licenses.gpl3Plus;
    mainProgram = "kana";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
