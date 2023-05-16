{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, installShellFiles
, installShellCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installManPages ? stdenv.hostPlatform == stdenv.buildPlatform
<<<<<<< HEAD
=======
, pkg-config
, Security
, libiconv
, openssl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, notmuch
, withImapBackend ? true
, withNotmuchBackend ? false
, withSmtpSender ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "himalaya";
<<<<<<< HEAD
  version = "0.8.4";
=======
  version = "0.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AImLYRRCL6IvoSeMFH2mbkNOvUmLwIvhWB3cOoqDljk=";
  };

  cargoSha256 = "deJZPaZW6rb7A6wOL3vcphBXu0F7EXc1xRwSDY/v8l4=";

  nativeBuildInputs = lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs = lib.optional withNotmuchBackend notmuch;
=======
    sha256 = "sha256-yAfNH9LSXlS/Hzi5kAuur5BX2vITMucprDzxhlV8RiY=";
  };

  cargoSha256 = "sha256-FXfh6T8dNsnD/V/wYSMDWs+ll0d1jg1Dc3cQT39b0ws=";

  nativeBuildInputs = [ ]
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) pkg-config;

  buildInputs = [ ]
    ++ (if stdenv.hostPlatform.isDarwin then [ Security libiconv ] else [ openssl ])
    ++ lib.optional withNotmuchBackend notmuch;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    description = "CLI to manage your emails.";
    homepage = "https://pimalaya.org/himalaya/";
=======
    description = "Command-line interface for email management";
    homepage = "https://github.com/soywod/himalaya";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    changelog = "https://github.com/soywod/himalaya/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod toastal yanganto ];
  };
}
