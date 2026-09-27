{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  glib,
  gst_all_1,
  livekit-libwebrtc,
  versionCheckHook,
  opentalk-controller,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opentalk-recorder";
  version = "0.14.1";

  src = fetchFromGitLab {
    domain = "gitlab.opencode.de";
    owner = "opentalk";
    repo = "recorder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/4HBb0CYSrT6p/ZvhIoSsH8/iHArth7Z+ZwmM+R7a5A=";
  };

  cargoHash = "sha256-MBatbEbVC/DfA+QpDonu2XzouFSZjFax8UiT0qLaAjk=";

  postPatch = ''
    # Dynamically link WebRTC instead of static
    substituteInPlace $cargoDepsCopy/webrtc-sys-*/build.rs \
      --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc"
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  env.LK_CUSTOM_WEBRTC = livekit-libwebrtc;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    inherit (opentalk-controller.passthru) updateScript;
  };

  meta = {
    description = "Secure video conferencing solution that was designed with productivity, digital sovereignty and privacy in mind";
    homepage = "https://gitlab.opencode.de/opentalk/recorder";
    changelog = "https://gitlab.opencode.de/opentalk/recorder/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    mainProgram = "opentalk-recorder";
  };
})
