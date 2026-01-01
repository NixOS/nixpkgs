{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
<<<<<<< HEAD
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyperfine";
  version = "1.20.0";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.19.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hyperfine";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ee889Fx2Mi2005SrlcKc7TwG8ZIpTqisfLebXYadvSg=";
  };

  cargoHash = "sha256-0e6QDVv//WQtfvrJj6jW1sEz7jFv3VC6UKLvclyytLs=";
=======
    rev = "v${version}";
    hash = "sha256-c8yK9U8UWRWUSGGGrAds6zAqxAiBLWq/RcZ6pvYNpgk=";
  };

  cargoHash = "sha256-eZpGqkowp/R//RqLRk3AIbTpW3i9e+lOWpfdli7S4uE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/hyperfine.1

    installShellCompletion \
      $releaseDir/build/hyperfine-*/out/hyperfine.{bash,fish} \
      --zsh $releaseDir/build/hyperfine-*/out/_hyperfine
  '';

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Command-line benchmarking tool";
    homepage = "https://github.com/sharkdp/hyperfine";
    changelog = "https://github.com/sharkdp/hyperfine/blob/v${finalAttrs.version}/CHANGELOG.md";
=======
  meta = {
    description = "Command-line benchmarking tool";
    homepage = "https://github.com/sharkdp/hyperfine";
    changelog = "https://github.com/sharkdp/hyperfine/blob/v${version}/CHANGELOG.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      mdaniels5757
      thoughtpolice
    ];
    mainProgram = "hyperfine";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
