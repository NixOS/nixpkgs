{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stax";
  # also update version of the vim plugin in
  # pkgs/applications/editors/vim/plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "cesarferreira";
    repo = "stax";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-bMs3XMiGP6sXCqdjna4xoV6CANOIWuISSzCaL5LYY4c=";
  };

  cargoHash = "sha256-Pi1q2qNLjQYr3Wla7rqrktNm0StszB2klcfzwAnF3tE=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "The fastest stacked-branch workflow for Git. Interactive TUI, smart PRs, safe undo. Written in Rust. ";
    homepage = "https://github.com/cesarferreira/stax";
    license = lib.licenses.mit;
    mainProgram = "stax";
    maintainers = with lib.maintainers; [
      henrikvtcodes
    ];
  };
})
