{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "eitype";
  version = "0.2.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Adam-D-Lewis";
    repo = "eitype";
    tag = finalAttrs.version;
    hash = "sha256-s5g6METDi8/jPEwZursorYWN8X96VlyVPtd8dCCVIlw=";
  };

  cargoHash = "sha256-k0JU3Y83aPHgQpyiG6DXxBzdYSMOmH42kPCxXWtNtkQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxkbcommon ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Type text through the Emulated Input protocol on Wayland";
    homepage = "https://github.com/Adam-D-Lewis/eitype";
    changelog = "https://github.com/Adam-D-Lewis/eitype/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iainlane ];
    mainProgram = "eitype";
    platforms = lib.platforms.linux;
  };
})
