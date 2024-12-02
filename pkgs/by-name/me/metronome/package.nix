{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, cargo
, wrapGAppsHook4
, desktop-file-utils
, libadwaita
, gst_all_1
, darwin
}:

stdenv.mkDerivation rec {
  pname = "metronome";
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "metronome";
    rev = version;
    hash = "sha256-Sn2Ua/XxPnJjcQvWeOPkphl+BE7/BdOrUIpf+tLt20U=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "metronome-${version}";
    hash = "sha256-HYO/IY5yGW8JLBxD/SZz16GFnwvv77kFl/x+QXhV+V0=";
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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  # Workaround for the gettext-sys issue
  # https://github.com/Koka/gettext-rs/issues/114
  env.NIX_CFLAGS_COMPILE = lib.optionalString
    (
      stdenv.cc.isClang &&
      lib.versionAtLeast stdenv.cc.version "16"
    )
    "-Wno-error=incompatible-function-pointer-types";

  meta = with lib; {
    description = "Keep the tempo";
    longDescription = ''
      Metronome beats the rhythm for you, you simply
      need to tell it the required time signature and
      beats per minutes. You can also tap to let the
      application guess the required beats per minute.
    '';
    homepage = "https://gitlab.gnome.org/World/metronome";
    license = licenses.gpl3Plus;
    mainProgram = "metronome";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
