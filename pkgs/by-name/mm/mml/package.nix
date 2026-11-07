{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, installShellFiles
, installShellCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installManPages ? stdenv.hostPlatform == stdenv.buildPlatform
, gnupg
, gpgme
, enableCompiler ? true
, enableInterpreter ? true
, enablePgpCommands ? false
, enablePgpGpg ? false
, enablePgpNative ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "mml";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8CFLtmN7CfcXcImRcqIaohT3vWWVfWzEwXIXvmL8MsQ=";
  };

  cargoSha256 = "35VEYViJJjD5rvaCPRJJSm/8bOO4BZKLOnynH6AQf+o=";

  nativeBuildInputs = lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs = lib.optionals enablePgpGpg [ gnupg gpgme ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ ]
    ++ lib.optional enableCompiler "compiler"
    ++ lib.optional enableInterpreter "interpreter"
    ++ lib.optional enablePgpCommands "pgp-commands"
    ++ lib.optional enablePgpGpg "pgp-gpg"
    ++ lib.optional enablePgpNative "pgp-native";

  postInstall = lib.optionalString installManPages ''
    mkdir -p $out/man
    $out/bin/mml man $out/man
    installManPage $out/man/*
  '' + lib.optionalString installShellCompletions ''
    installShellCompletion --cmd mml \
      --bash <($out/bin/mml completion bash) \
      --fish <($out/bin/mml completion fish) \
      --zsh <($out/bin/mml completion zsh)
  '';

  meta = with lib; {
    description = "CLI to compile MML messages to MIME messages and interpret MIME messages as MML messages";
    homepage = "https://pimalaya.org/mml/";
    changelog = "https://github.com/soywod/mml/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod ];
  };
}
