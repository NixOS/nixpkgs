{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "fclones";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
<<<<<<< HEAD
    repo = "fclones";
    tag = "v${finalAttrs.version}";
=======
    repo = pname;
    rev = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-OCRfJh6vfAkL86J1GuLgfs57from3fx0NS1Bh1+/oXE=";
  };

  cargoHash = "sha256-aEjsBhm0iPysA1Wz1Ea7rtX0g/yH/rklUkYV/Elxcq8=";

  nativeBuildInputs = [ installShellFiles ];

  # device::test_physical_device_name test fails on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # ofborg sometimes fails with "Resource temporarily unavailable"
    "--skip=cache::test::return_none_if_different_transform_was_used"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # setting PATH required so completion script doesn't use full path
    export PATH="$PATH:$out/bin"
    installShellCompletion --cmd $pname \
      --bash <(fclones complete bash) \
      --fish <(fclones complete fish) \
      --zsh <(fclones complete zsh)
  '';

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    changelog = "https://github.com/pkolaczk/fclones/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cyounkins
      progrm_jarvis
    ];
    mainProgram = "fclones";
  };
})
=======
  meta = with lib; {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    changelog = "https://github.com/pkolaczk/fclones/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      cyounkins
    ];
    mainProgram = "fclones";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
