{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mermaid-rs-renderer";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "mermaid-rs-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FmYiGAUTdHLBHmMrX4I1Lax+WTevLeW2+TSVhV0TUCk=";
  };

  cargoHash = "sha256-EICrvDm97hXvGbmp6zOMSEKCdJ6MPho2Y0llWQ9zHus=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast native Rust Mermaid diagram renderer";
    longDescription = ''
      mmdr renders diagrams 100-1800x faster than mermaid-cli by
      eliminating browser overhead.
    '';
    homepage = "https://github.com/1jehuang/mermaid-rs-renderer";
    license = lib.licenses.mit;
    mainProgram = "mmdr";
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
