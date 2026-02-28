{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-applet-pomodoro";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "bgub";
    repo = "cosmic-ext-applet-pomodoro";
    tag = finalAttrs.version;
    hash = "sha256-Ep0osOVon8DvhvQSHjAzYGrFBtEaqrVATOAnG4ujnYc=";
  };

  cargoHash = "sha256-ocELklj50LkRhXMF4igT6jIxOWPdY3Cr74CceB+0v24=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-pomodoro"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A pomodoro timer applet for the COSMIC desktop";
    homepage = "https://github.com/bgub/cosmic-ext-applet-pomodoro";
    changelog = "https://github.com/bgub/cosmic-ext-applet-pomodoro/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mpl20;
    mainProgram = "cosmic-ext-applet-pomodoro";
    maintainers = with lib.maintainers; [ bgub ];
    platforms = lib.platforms.linux;
  };
})
