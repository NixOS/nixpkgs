{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, installShellFiles
, installShellCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installManPages ? stdenv.hostPlatform == stdenv.buildPlatform
, notmuch
, withImapBackend ? true
, withNotmuchBackend ? false
, withSmtpSender ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "himalaya";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N/g5//yIVot2vHPD/staVneO9eWPx0jT5dnYpcs1SZU=";
  };

  cargoSha256 = "hjkCvyzsBzfP4FGSli0acrVCfbRC0V7uBecV5VSiClI=";

  nativeBuildInputs = lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs = lib.optional withNotmuchBackend notmuch;

  buildNoDefaultFeatures = true;
  buildFeatures = [ ]
    ++ lib.optional withImapBackend "imap-backend"
    ++ lib.optional withNotmuchBackend "notmuch-backend"
    ++ lib.optional withSmtpSender "smtp-sender";

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
    description = "CLI to manage your emails.";
    homepage = "https://pimalaya.org/himalaya/";
    changelog = "https://github.com/soywod/himalaya/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod toastal yanganto ];
  };
}
