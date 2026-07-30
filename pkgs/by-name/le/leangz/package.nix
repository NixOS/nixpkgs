{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leangz";
  # nixpkgs-update: no auto update
  version = "0.1.19"; # Should match LEANTAR_VERSION in leanprover/lean4/CMakeLists.txt

  src = fetchFromGitHub {
    owner = "digama0";
    repo = "leangz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kDvaydStWiJYCmKjoU39tuOQHNw5Zo577GeAvlENO2o=";
  };

  cargoHash = "sha256-n3iqdRbXcSsCL+8/vDcdOXwnbU9k7DTSKR14gZ4Zlxg=";

  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Lean 4 .olean file (de)compressor";
    homepage = "https://github.com/digama0/leangz";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ niklashh ];
    mainProgram = "leantar";
  };
})
