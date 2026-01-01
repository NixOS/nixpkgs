{
  lib,
<<<<<<< HEAD
=======
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  testers,
  nix-update-script,
<<<<<<< HEAD
  go-md2man,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "angrr";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linyinfeng";
    repo = "angrr";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Z+B0MO5ZoPJveO571mlzNVedBEac7P4RE7Cq8e/9bJk=";
  };

  cargoHash = "sha256-j36vyfIP63Qmd55vaVb9buqrCItXwFalelzU8BlKm9s=";

  buildAndTestSubdir = "angrr";

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];
  postBuild = ''
    mkdir --parents build/{man-pages,shell-completions}
    cargo xtask man-pages --out build/man-pages
    cargo xtask shell-completions --out build/shell-completions
  '';
  postInstall = ''
    install -m400 -D ./direnv/angrr.sh $out/share/direnv/lib/angrr.sh
    installManPage build/man-pages/*
    installShellCompletion --cmd angrr \
      --bash build/shell-completions/angrr.bash \
      --fish build/shell-completions/angrr.fish \
      --zsh  build/shell-completions/_angrr
=======
    hash = "sha256-pBVbzrTy/IWIo6WlhM1qgowfxSU31awyHcRDHNArBMo=";
  };

  cargoHash = "sha256-DoQIJCs36ZmTxdsDCzquKAeOSIUBbo2V+DTx68FZiu4=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    install -m400 -D ./direnv/angrr.sh $out/share/direnv/lib/angrr.sh
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd angrr \
      --bash <($out/bin/angrr completion bash) \
      --fish <($out/bin/angrr completion fish) \
      --zsh  <($out/bin/angrr completion zsh)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  passthru = {
    tests = {
      module = nixosTests.angrr;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
<<<<<<< HEAD
    description = "Auto Nix GC Root Retention";
=======
    description = "Tool for auto Nix GC roots retention";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/linyinfeng/angrr";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ yinfeng ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "angrr";
  };
})
