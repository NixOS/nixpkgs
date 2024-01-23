{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, installShellFiles
, installShellCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installManPages ? stdenv.hostPlatform == stdenv.buildPlatform
, notmuch
, gpgme
, withMaildir ? true
, withImap ? true
, withNotmuch ? false
, withSendmail ? true
, withSmtp ? true
, withPgpCommands ? false
, withPgpGpg ? false
, withPgpNative ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "himalaya";
  version = "1.0.0-beta";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-39XYtxmo/12hkCS7zVIQi3UbLzaIKH1OwfdDB/ghU98=";
  };

  cargoSha256 = "HIDmBPrcOcK2coTaD4v8ntIZrv2SwTa8vUTG8Ky4RhM=";

  nativeBuildInputs = [ ]
    ++ lib.optional withPgpGpg pkg-config
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs = [ ]
    ++ lib.optional withNotmuch notmuch
    ++ lib.optional withPgpGpg gpgme;

  buildNoDefaultFeatures = true;
  buildFeatures = [ ]
    ++ lib.optional withMaildir "maildir"
    ++ lib.optional withImap "imap"
    ++ lib.optional withNotmuch "notmuch"
    ++ lib.optional withSmtp "smtp"
    ++ lib.optional withSendmail "sendmail"
    ++ lib.optional withPgpCommands "pgp-commands"
    ++ lib.optional withPgpGpg "pgp-gpg"
    ++ lib.optional withPgpNative "pgp-native";

  postInstall = lib.optionalString installManPages ''
    mkdir -p $out/man
    $out/bin/himalaya man $out/man
    installManPage $out/man/*
  '' + lib.optionalString installShellCompletions ''
    installShellCompletion --cmd himalaya \
      --bash <($out/bin/himalaya completion bash) \
      --fish <($out/bin/himalaya completion fish) \
      --zsh <($out/bin/himalaya completion zsh)
  '';

  meta = with lib; {
    description = "CLI to manage emails";
    homepage = "https://pimalaya.org/himalaya/cli/latest/";
    changelog = "https://github.com/soywod/himalaya/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod toastal yanganto ];
  };
}
