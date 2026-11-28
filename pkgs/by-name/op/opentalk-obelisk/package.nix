{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  openssl,
  livekit-libwebrtc,
  versionCheckHook,
  opentalk-controller,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opentalk-obelisk";
  version = "0.19.4";

  src = fetchFromGitLab {
    domain = "gitlab.opencode.de";
    owner = "opentalk";
    repo = "obelisk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3TIqqBajc8LAzJ7G9vZU3Jwpa17ll0fWr66xXb03Tjw=";
  };

  cargoHash = "sha256-aCpGwrHmkkJm5wJfWBn/hmqddIkmKLkRhemoP6qNIjQ=";

  postPatch = ''
    # Dynamically link WebRTC instead of static
    substituteInPlace $cargoDepsCopy/webrtc-sys-*/build.rs \
      --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc"
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.LK_CUSTOM_WEBRTC = livekit-libwebrtc;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    inherit (opentalk-controller.passthru) updateScript;
  };

  meta = {
    description = "SIP bridge for the OpenTalk conference system";
    homepage = "https://gitlab.opencode.de/opentalk/obelisk";
    changelog = "https://gitlab.opencode.de/opentalk/obelisk/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    mainProgram = "opentalk-obelisk";
  };
})
