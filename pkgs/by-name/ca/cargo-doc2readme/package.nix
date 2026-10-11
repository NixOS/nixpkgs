{
  lib,
  rustPlatform,
  fetchFromGitea,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-doc2readme";
  version = "0.6.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "msrd0";
    repo = "cargo-doc2readme";
    tag = finalAttrs.version;
    hash = "sha256-9LIsidrs/uyc0e8AdyAfBVLXNUXQlphhM/pbblzAtZo=";
  };

  cargoHash = "sha256-dhieV4hEuHEGY2GQBE8aJ+9DQFfNng4QZYp4zwP+r1U=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Create a readme file containing the rustdoc comments from your code";
    longDescription = ''
      `cargo doc2readme` is a cargo subcommand to create a readme file
      to display on Codeberg, GitHub or crates.io, containing the
      rustdoc comments from your code.
    '';
    homepage = "https://codeberg.org/msrd0/cargo-doc2readme";
    changelog = "https://codeberg.org/msrd0/cargo-doc2readme/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "cargo-doc2readme";
  };
})
