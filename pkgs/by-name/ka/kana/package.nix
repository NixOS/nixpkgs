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
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "kana";
  version = "1.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "fkinoshita";
    repo = "Kana";
    rev = "v${version}";
    hash = "sha256-/Ri723ub8LMlhbPObC83bay63JuWIQpgxAT5UUYuwZI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "kana-${version}";
    hash = "sha256-Z7DpPe8/Tt8AcLjCwKbwzQTsLe6YvWBCG7DlDkkklew=";
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

  buildInputs =
    [
      libadwaita
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-bad
      gst-plugins-good
    ])
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Foundation
    ];

  # Workaround for the gettext-sys issue
  # https://github.com/Koka/gettext-rs/issues/114
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16"
  ) "-Wno-error=incompatible-function-pointer-types";

  meta = with lib; {
    description = "Learn Japanese hiragana and katakana characters";
    homepage = "https://gitlab.gnome.org/fkinoshita/kana";
    license = licenses.gpl3Plus;
    mainProgram = "kana";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
