{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  pkg-config,
  dbus,
  glib,
  glib-networking,
  gst_all_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-applet-mare-player";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "glima";
    repo = "mare-player";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oxaL1dLNq2B6Vn6ZzztWG20pAjLTdWtIiOSkCMo31YQ=";
  };

  cargoHash = "sha256-R87TNV0Fn6VIsIdotjnpS9KYPeD5QuhHVaBS2c1dSt8=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  # The install requires the mare-video-window workspace member.
  cargoBuildFlags = [ "--workspace" ];
  cargoTestFlags = [ "--workspace" ];

  # These tests fail in the Nix build environment for some reason.
  checkFlags = [
    "--skip=image_cache::tests"
    "--skip=language_loader::language_loader_current_language_is_english_fallback"
  ];

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    dbus
    glib
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  preFixup = ''
    libcosmicAppWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/glima/mare-player";
    description = "COSMIC desktop applet for TIDAL music streaming";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyabinary ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-applet-mare";
  };
})
