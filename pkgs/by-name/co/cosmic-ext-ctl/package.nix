{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  cosmic-comp,
}:
let
  version = "1.1.0";
in
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-ctl";
  inherit version;

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    tag = "v${version}";
    hash = "sha256-dcUzrJcwJpzbYPuqdHgm43NYbaowsFmFP4sS0cfzNAg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EReo2hkBaIO1YOBx4D9rQSXlx+3NK5VQtj59jfZZI/0=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/cosmic-ctl";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for COSMIC Desktop configuration management";
    changelog = "https://github.com/cosmic-utils/cosmic-ctl/releases/tag/v${version}";
    homepage = "https://github.com/cosmic-utils/cosmic-ctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "cosmic-ctl";
    inherit (cosmic-comp.meta) platforms;
  };
}
