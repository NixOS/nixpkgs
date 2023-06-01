{ lib
, rustPlatform
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
, withRusttlsTls ? true
, withRusttlsNativeCerts ? withRusttlsTls
, withNativeTls ? false
, withNativeTlsVendored ? withNativeTls
, withImapBackend ? true
, withNotmuchBackend ? false
, withSmtpSender ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "himalaya";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "HmH4qL70ii8rS8OeUnUxsy9/wMx+f2SBd1AyRqlfKfc=";
  };

  cargoSha256 = "NJFOtWlfKZRLr9vvDvPQjpT4LGMeytk0JFJb0r77bwE=";

  nativeBuildInputs = [ ]
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles
    ++ lib.optional (withNativeTls && !stdenv.hostPlatform.isDarwin) pkg-config;

  buildInputs = [ ]
    ++ lib.optional withNativeTls (if stdenv.hostPlatform.isDarwin then [ Security libiconv ] else [ openssl ])
    ++ lib.optional withNotmuchBackend notmuch;

  buildNoDefaultFeatures = true;
  buildFeatures = [ ]
    ++ lib.optional withRusttlsTls "rustls-tls"
    ++ lib.optional withRusttlsNativeCerts "rustls-native-certs"
    ++ lib.optional withNativeTls "native-tls"
    ++ lib.optional withNativeTlsVendored "native-tls-vendored"
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
