{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  rustc,
  appstream,
  blueprint-compiler,
  dav1d,
  desktop-file-utils,
  gst_all_1,
  gtk4,
  lcms,
  libadwaita,
  libseccomp,
  libwebp,
  meson,
  ninja,
  pkg-config,
  nix-update-script,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "identity";
  version = "0.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "identity";
    rev = "v${version}";
    hash = "sha256-h8/mWGuosBiQRpoW8rINJht/7UBVEnUnTKY5HBCAyw4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-oO7l4zVKR93fFLqkY67DfzrAA9kUN06ov9ogwDuaVlE=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoCheckHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    dav1d
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk4
    lcms
    libadwaita
    libwebp
    libseccomp
  ];

  mesonBuildType = "release";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  cargoCheckType = if (finalAttrs.mesonBuildType != "debug") then "release" else "debug";

  checkPhase = ''
    runHook preCheck

    cargoCheckHook
    mesonCheckPhase

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Program for comparing multiple versions of an image or video";
    homepage = "https://gitlab.gnome.org/YaLTeR/identity";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "identity";
    platforms = lib.platforms.linux;
  };
}
