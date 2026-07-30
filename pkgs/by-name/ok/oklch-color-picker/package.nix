{
  lib,
  nix-update-script,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  autoPatchelfHook,
  wayland,
  libxkbcommon,
  libGL,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oklch-color-picker";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "eero-lehtinen";
    repo = "oklch-color-picker";
    tag = finalAttrs.version;
    hash = "sha256-AdLpP01VeeAAOBEeX/dxLPdAqTfgH9X+NDCmFgqA3hs=";
  };

  cargoHash = "sha256-FB8zvWhO+ZbzWjkQCnf3ghgM+IL4px7QNO4dLPcczec=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  runtimeDependencies = [
    libGL
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libxkbcommon
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Color picker for Oklch";
    longDescription = ''
      A standalone color picker application using the Oklch
      colorspace (based on Oklab)
    '';
    homepage = "https://github.com/eero-lehtinen/oklch-color-picker";
    changelog = "https://github.com/eero-lehtinen/oklch-color-picker/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ videl ];
  };
})
