{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  scdoc,
  versionCheckHook,
  nix-update-script,
  nixfmt,
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixfmt-rs";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixfmt-rs";
    tag = finalAttrs.version;
    hash = "sha256-eBVi22+EGMYWv2t/seoPqou8PuABxVcsWTFcrNYP6So=";
  };

  cargoHash = "sha256-fadjOtfB8bFuhTN9mAmi2A526boW7Aje39IBjdxszok=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postBuild = ''
    scdoc < docs/nixfmt.1.scd > nixfmt.1
  '';

  postInstall = ''
    installManPage nixfmt.1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeCheckInputs = [
    gitMinimal
    nixfmt
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Mic92/nixfmt-rs/releases/tag/${finalAttrs.version}";
    description = "Rust reimplementation of nixfmt that produces byte-identical output to the Haskell original";
    homepage = "https://github.com/Mic92/nixfmt-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      drupol
      mic92
    ];
    mainProgram = "nixfmt";
  };
})
