{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libseccomp,
  libsodium,
  pkg-config,
  pkgs,
  sqlite,
  stdenv,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "sn0int";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tiJLwlxZ9ndircgkH23ew+3QJeuuqt93JahAtFPcuG8=";
  };

  cargoHash = "sha256-3FrUlv6UxULsrvgyV5mlry9j3wFMiXZVoxk6z6pRM3I=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      libsodium
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libseccomp
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      pkgs.darwin.apple_sdk.frameworks.Security
    ];

  # One of the dependencies (chrootable-https) tries to read "/etc/resolv.conf"
  # in "checkPhase", hence fails in sandbox of "nix".
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sn0int \
      --bash <($out/bin/sn0int completions bash) \
      --fish <($out/bin/sn0int completions fish) \
      --zsh  <($out/bin/sn0int completions zsh)
  '';

  meta = with lib; {
    description = "Semi-automatic OSINT framework and package manager";
    homepage = "https://github.com/kpcyrd/sn0int";
    changelog = "https://github.com/kpcyrd/sn0int/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [
      fab
      xrelkd
    ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "sn0int";
  };
}
