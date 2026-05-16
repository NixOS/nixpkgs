{
  lib,
  buildPackages,
  pkgsCross,
  rustPlatform,
  stdenv,
  glibcLocales,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

let
  canExecuteHost = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "argc";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "argc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-in2ymxiSZbs3wZwo/aKfu11x8SLx4OHOoa/tVxr3FyM=";
  };

  cargoHash = "sha256-2UmI9CMa130T7ML9iVNQ8Zh/stiFg05eBtF1sprmwk8=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (!canExecuteHost) buildPackages.argc;

  postInstall = ''
    ARGC=${if canExecuteHost then "\${!outputBin}/bin/argc" else "argc"}

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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--argc-version";

  passthru = {
    updateScript = nix-update-script { };
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
    changelog = "https://github.com/sigoden/argc/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      # or
      asl20
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
