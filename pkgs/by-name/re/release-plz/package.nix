{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  perl,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "release-plz";
<<<<<<< HEAD
  version = "0.3.150";
=======
  version = "0.3.149";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "MarcoIeni";
    repo = "release-plz";
    rev = "release-plz-v${version}";
<<<<<<< HEAD
    hash = "sha256-gV1B7c7yC5KBjQ5y44dAgMUuGtL55ICM++kNShNh/nM=";
  };

  cargoHash = "sha256-o1Gds4UDZRVstPNPaisriUUeX0fabqLrS5TSqXMEB1c=";
=======
    hash = "sha256-1n0cX8xU62LHGWs0yk8gUg1r3PBIbXih+9BK3UYseqU=";
  };

  cargoHash = "sha256-BB5oJL5QKceQySr1hzOeCm6TzALfw3Ryw8MHOB0VeaI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  buildAndTestSubdir = "crates/release_plz";

  # Tests depend on additional infrastructure to be running locally
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash <($out/bin/${meta.mainProgram} generate-completions bash) \
      --fish <($out/bin/${meta.mainProgram} generate-completions fish) \
      --zsh <($out/bin/${meta.mainProgram} generate-completions zsh)
  '';

  meta = {
    description = "Publish Rust crates from CI with a Release PR";
    homepage = "https://release-plz.ieni.dev";
    changelog = "https://github.com/MarcoIeni/release-plz/blob/release-plz-v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "release-plz";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
