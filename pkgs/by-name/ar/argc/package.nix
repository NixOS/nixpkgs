{
  lib,
  buildPackages,
  pkgsCross,
  rustPlatform,
  stdenv,
  glibcLocales,
  fetchFromGitHub,
  installShellFiles,
}:

let
  canExecuteHost = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "argc";
    rev = "v${version}";
    hash = "sha256-pOkZmk7boFPqHHBDet/on6Y8V2Ik+hpqN0cUtY0BiR0=";
  };

  cargoHash = "sha256-FxhDnTy/KAeN0Zd5I12EUgXRc0VhHN0lRm5DQyCinyw=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (!canExecuteHost) buildPackages.argc;

  postInstall = ''
    ARGC=${if canExecuteHost then ''''${!outputBin}/bin/argc'' else "argc"}

    installShellCompletion --cmd argc \
      --bash <("$ARGC" --argc-completions bash) \
      --fish <("$ARGC" --argc-completions fish) \
      --zsh <("$ARGC" --argc-completions zsh)
  '';

  disallowedReferences = lib.optional (!canExecuteHost) buildPackages.argc;

  env =
    {
      LANG = "C.UTF-8";
    }
    // lib.optionalAttrs (glibcLocales != null) {
      LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
    };

  passthru = {
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

  meta = with lib; {
    description = "Command-line options, arguments and sub-commands parser for bash";
    mainProgram = "argc";
    homepage = "https://github.com/sigoden/argc";
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
    license = with licenses; [
      mit
      # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
