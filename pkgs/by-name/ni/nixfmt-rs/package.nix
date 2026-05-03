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
  version = "0.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixfmt-rs";
    tag = finalAttrs.version;
    hash = "sha256-H4APJn0NGaD2LrkjcJ7io+fu3aKoO0Cn2BJk731YlqQ=";
  };

  cargoHash = "sha256-gJq6PxA6WaWObHnIL7jsKQBOSHQj31kzlrM95OY27ro=";

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
