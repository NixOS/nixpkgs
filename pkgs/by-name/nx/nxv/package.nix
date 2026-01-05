{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nxv";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jamesbrink";
    repo = "nxv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tKjb+B65ZrLIJ7aDYGC3kj71iAXoFmAaj5I8+o4EzlM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-RW3WrG1A/J1xuWWcHOARG6EEmSWWnDeycAtbppY52OI=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find any version of any Nix package instantly";
    longDescription = ''
      nxv indexes the entire nixpkgs git history to help you discover
      when packages were added, which versions existed, and the exact
      commit to use with `nix shell nixpkgs/<commit>#package`.
    '';
    homepage = "https://nxv.urandom.io";
    changelog = "https://github.com/jamesbrink/nxv/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "nxv";
  };
})
