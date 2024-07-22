{
  lib,
  buildPackages,
  pkgsCross,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

let
  canExecuteHost = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "argc";
    rev = "v${version}";
    hash = "sha256-I5dx0/aHCGmzgAEBL9gZcG7DFWCkSpndGvv2enQIZGU=";
  };

  cargoHash = "sha256-30BY6ceJj0UeZE30O/LovR+YXSd7jIxFo6ojKFuecFM=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (!canExecuteHost) buildPackages.argc;

  postInstall = ''
    ARGC=${if canExecuteHost then ''''${!outputBin}/bin/argc'' else "argc"}

    installShellCompletion --cmd argc \
      --bash <("$ARGC" --argc-completions bash) \
      --fish <("$ARGC" --argc-completions fish) \
      --zsh <("$ARGC" --argc-completions zsh)
  '';

  checkFlags = [
    # This test fails to escape some chars
    "--skip=misc::escape"
  ];

  disallowedReferences = lib.optional (!canExecuteHost) buildPackages.argc;

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

  meta = {
    description = "Command-line options, arguments and sub-commands parser for bash";
    mainProgram = "argc";
    homepage = "https://github.com/sigoden/argc";
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      # or
      asl20
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
