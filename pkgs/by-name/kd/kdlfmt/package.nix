{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kdlfmt";
<<<<<<< HEAD
  version = "0.1.5";
=======
  version = "0.1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-IiR7luc474uL0B2lCGEl6taTM2VXRQCjo88TuWOh7ic=";
  };

  cargoHash = "sha256-ZlBsEPvATh9i3+davxTkJQeH2eeSJzoyweAhZhNkBgk=";
=======
    hash = "sha256-VHcpF9CTRDl9dtX/rZeDKVoCerI1sNjwURBpiE9bH80=";
  };

  cargoHash = "sha256-A8pp4IWL8hR4G1WDNFo6e3BVRxuVjfazIKOwCEGN7Rc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kdlfmt \
      --bash <($out/bin/kdlfmt completions bash) \
      --fish <($out/bin/kdlfmt completions fish) \
      --zsh <($out/bin/kdlfmt completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      airrnot
      defelo
    ];
    mainProgram = "kdlfmt";
  };
})
