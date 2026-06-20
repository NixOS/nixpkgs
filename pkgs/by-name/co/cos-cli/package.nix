{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  cosmic-comp,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cos-cli";
  version = "0.1.0-git";

  src = fetchFromGitHub {
    owner = "estin";
    repo = "cos-cli";
    rev = "9c23bd2f66b05e54e36a82f6dc93c14a62fc054f";
    hash = "sha256-xTRJjgi3FDCKoxRdQU6Xuf2vV5PEZXWhNcon17LIbfw=";
  };

  cargoHash = "sha256-11jOmXTkp/J0j7BZuLltnSk4I5Ssj8iyeRvE2pYXDhw=";

  doInstallCheck = true;

  # TODO
  # nativeInstallCheckInputs = [ versionCheckHook ];
  # versionCheckProgram = #"${placeholder "out"}/bin/cos-cli";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A CLI utility for COSMIC Wayland toplevel and workspace management";

    # TODO
    # changelog = "https://github.com/cosmic-utils/cosmic-ctl/releases/tag/v${finalAttrs.version}";

    homepage = "https://github.com/estin/cos-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hiro98 ];
    mainProgram = "cos-cli";
    inherit (cosmic-comp.meta) platforms;
  };
})
