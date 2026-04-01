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
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "eero-lehtinen";
    repo = "oklch-color-picker";
    tag = finalAttrs.version;
    hash = "sha256-IwG3oUYArr6cHSa3fNukQ7CjasUMaVWX9JXChSHTnEs=";
  };

  cargoHash = "sha256-Vs6bMHHHRdqSYjOzJuq2agmuXSjGRagIATVzQa3Z/M8=";

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
