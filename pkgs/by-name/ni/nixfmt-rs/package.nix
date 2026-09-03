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
  version = "0.5.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixfmt-rs";
    tag = finalAttrs.version;
    hash = "sha256-Gapz+ra0dyGHfY028QTbVVoGwu0yXaQOgKcarzX1nYo=";
  };

  cargoHash = "sha256-SN/IXbJpAW9kLVn7y4K4oI3DcTX8ekwWWJVTn+7oNhY=";

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
