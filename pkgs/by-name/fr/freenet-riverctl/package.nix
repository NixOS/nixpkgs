{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rustc,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "freenet-riverctl";
  version = "0.2.16";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "freenet";
    repo = "river";
    tag = "riverctl-v${finalAttrs.version}";
    hash = "sha256-ruDIbsIKEbfGIcxdwih/ye+sLHvxRFO9Ddghr40L0Qc=";
  };

  cargoHash = "sha256-oQwbnAkGifnzHyRes91ay/w/zcXmbTzNDfyx3dCYJCQ=";

  # This integration test needs a sibling freenet-core workspace checkout
  postPatch = ''
    rm cli/tests/message_flow.rs
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  cargoBuildFlags = [ "--package=riverctl" ];
  cargoTestFlags = [ "--package=riverctl" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=riverctl-v([\\d.]+)" ];
  };

  meta = {
    description = "Command-line client for driving River rooms";
    homepage = "https://freenet.org/river/";
    donationPage = "https://freenet.org/donate/";
    changelog = "https://github.com/freenet/river/releases/tag/riverctl-v${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "riverctl";
    inherit (rustc.meta) platforms;
  };
})
