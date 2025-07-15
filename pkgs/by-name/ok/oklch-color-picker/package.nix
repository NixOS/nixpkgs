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
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "eero-lehtinen";
    repo = "oklch-color-picker";
    tag = "${finalAttrs.version}";
    hash = "sha256-tPYxcZghGR1YZl1bwoDDIBmbTVGuksCpfgLYwG+k4Ws=";
  };

  cargoHash = "sha256-tdIkvBYKfcbCYXhDbIwXNNbNb4X32uBwDh3mAyqt/IM=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  runtimeDependencies = [
    wayland
    libxkbcommon
    libGL
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
    broken = stdenv.hostPlatform.isDarwin;
  };
})
