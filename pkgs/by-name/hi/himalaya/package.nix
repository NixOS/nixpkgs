{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, darwin
, installShellFiles
, installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, notmuch
, gpgme
, buildNoDefaultFeatures ? false
, buildFeatures ? []
}:

rustPlatform.buildRustPackage rec {
  # Learn more about available cargo features at:
  #  - <https://pimalaya.org/himalaya/cli/latest/installation.html#cargo>
  inherit buildNoDefaultFeatures buildFeatures;

  pname = "himalaya";
  version = "1.0.0-beta.4";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NrWBg0sjaz/uLsNs8/T4MkUgHOUvAWRix1O5usKsw6o=";
  };

  cargoHash = "sha256-YS8IamapvmdrOPptQh2Ef9Yold0IK1XIeGs0kDIQ5b8=";

  NIX_LDFLAGS = lib.optionals stdenv.hostPlatform.isDarwin [
    "-F${darwin.apple_sdk.frameworks.AppKit}/Library/Frameworks"
    "-framework"
    "AppKit"
  ];

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional (builtins.elem "pgp-gpg" buildFeatures) pkg-config
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs = [ ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit Cocoa Security ])
    ++ lib.optional (builtins.elem "notmuch" buildFeatures) notmuch
    ++ lib.optional (builtins.elem "pgp-gpg" buildFeatures) gpgme;

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
    mainProgram = "himalaya";
    homepage = "https://pimalaya.org/himalaya/cli/latest/";
    changelog = "https://github.com/soywod/himalaya/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod toastal yanganto ];
  };
}
