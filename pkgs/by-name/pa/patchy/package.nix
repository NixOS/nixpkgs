{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "1.2.7";
in
rustPlatform.buildRustPackage {
  pname = "patchy";
  inherit version;

  src = fetchFromGitHub {
    owner = "nik-rev";
    repo = "patchy";
    tag = "v${version}";
    hash = "sha256-Npb+qcguxZAvWggJC5NtxCeUCU/nOtjCbK5gfkDTkfw=";
  };
  cargoHash = "sha256-vtKIDmfKSSZjorIGQ13OYrdmzabS5//j2/n7kJC9O7k=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Makes it easy to maintain personal forks";
    longDescription = ''
      Patchy makes it easy to declaratively manage personal forks by
      automatically merging pull request of your liking to have more
      features.
    '';
    homepage = "https://github.com/nik-rev/patchy";
    changelog = "https://github.com/nik-rev/patchy/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "patchy";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
