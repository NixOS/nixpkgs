{ lib
, rustPackages_1_70
, fetchFromGitHub
, stdenv
, installShellFiles
, installShellCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installManPages ? stdenv.hostPlatform == stdenv.buildPlatform
, pkg-config
, Security
, libiconv
, openssl
, notmuch
, withImapBackend ? true
, withNotmuchBackend ? false
, withSmtpSender ? true
}:

let
  rustPlatform = rustPackages_1_70.rustPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "himalaya";
  version = "1.0.0-beta";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-39XYtxmo/12hkCS7zVIQi3UbLzaIKH1OwfdDB/ghU98=";
  };

  cargoSha256 = "sha256-HIDmBPrcOcK2coTaD4v8ntIZrv2SwTa8vUTG8Ky4RhM=";

  nativeBuildInputs = [ ]
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) pkg-config;

  buildInputs = [ ]
    ++ (if stdenv.hostPlatform.isDarwin then [ Security libiconv ] else [ openssl ])
    ++ lib.optional withNotmuchBackend notmuch;

  buildNoDefaultFeatures = true;
  buildFeatures = [ "maildir" "sendmail" ]
    ++ lib.optional withImapBackend "imap"
    ++ lib.optional withNotmuchBackend "notmuch"
    ++ lib.optional withSmtpSender "smtp";

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
    description = "Command-line interface for email management";
    homepage = "https://github.com/soywod/himalaya";
    changelog = "https://github.com/soywod/himalaya/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod toastal yanganto ];
  };
}
