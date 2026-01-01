{
  lib,
  buildPackages,
  pkgsCross,
  rustPlatform,
  stdenv,
  glibcLocales,
  fetchFromGitHub,
  installShellFiles,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  canExecuteHost = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
=======
rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "argc";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "argc";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    rev = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-in2ymxiSZbs3wZwo/aKfu11x8SLx4OHOoa/tVxr3FyM=";
  };

  cargoHash = "sha256-2UmI9CMa130T7ML9iVNQ8Zh/stiFg05eBtF1sprmwk8=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (!canExecuteHost) buildPackages.argc;

  postInstall = ''
    ARGC=${if canExecuteHost then ''''${!outputBin}/bin/argc'' else "argc"}

    installShellCompletion --cmd argc \
      --bash <("$ARGC" --argc-completions bash) \
      --fish <("$ARGC" --argc-completions fish) \
      --zsh <("$ARGC" --argc-completions zsh)
  '';

  disallowedReferences = lib.optional (!canExecuteHost) buildPackages.argc;

  env = {
    LANG = "C.UTF-8";
  }
  // lib.optionalAttrs (glibcLocales != null) {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--argc-version";

  passthru = {
    updateScript = nix-update-script { };
=======
  passthru = {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    tests = {
      cross =
        (
          if stdenv.hostPlatform.isDarwin then
            if stdenv.hostPlatform.isAarch64 then pkgsCross.x86_64-darwin else pkgsCross.aarch64-darwin
          else if stdenv.hostPlatform.isAarch64 then
            pkgsCross.gnu64
          else
            pkgsCross.aarch64-multiplatform
        ).argc;
    };
  };

  meta = {
    description = "Command-line options, arguments and sub-commands parser for bash";
    mainProgram = "argc";
    homepage = "https://github.com/sigoden/argc";
<<<<<<< HEAD
    changelog = "https://github.com/sigoden/argc/releases/tag/v${finalAttrs.version}";
=======
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = with lib.licenses; [
      mit
      # or
      asl20
    ];
<<<<<<< HEAD
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
=======
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
