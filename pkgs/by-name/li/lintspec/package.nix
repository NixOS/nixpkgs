{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lintspec";
<<<<<<< HEAD
  version = "0.12.2";
=======
  version = "0.12.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-/+PcSLXSB2c0lJ4LSWwqwrhAmswnAlziGduMNXcxcak=";
  };

  cargoHash = "sha256-llPE52OHEFasWtzNCpBwYRm+7qX1kqIK7eGpYmeJExY=";
=======
    hash = "sha256-uIs2pVbAdqb49LGtaYfm76tyCqrAqs4iWPe8Eqa4C8w=";
  };

  cargoHash = "sha256-HbrA4olK2tSTiaGzV4MuEtG9N048wPp+m75aOxN1pZE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cargoBuildFlags = [
    "--package"
    "lintspec"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lintspec \
      --bash <($out/bin/lintspec completions -s bash) \
      --fish <($out/bin/lintspec completions -s fish) \
      --zsh <($out/bin/lintspec completions -s zsh)
  '';

  meta = {
    description = "Blazingly fast linter for NatSpec comments in Solidity code";
    homepage = "https://github.com/beeb/lintspec";
    changelog = "https://github.com/beeb/lintspec/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "lintspec";
  };
})
