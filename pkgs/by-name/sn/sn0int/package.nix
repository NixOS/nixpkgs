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
    repo = "sn0int";
    tag = "v${version}";
    hash = "sha256-tiJLwlxZ9ndircgkH23ew+3QJeuuqt93JahAtFPcuG8=";
  };

  cargoHash = "sha256-nDgWNm5HTvFEMQhUUnU7o2Rpzl3/bGwyB0N9Z1KorDs=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libsodium
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libseccomp
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

  meta = {
    description = "Semi-automatic OSINT framework and package manager";
    homepage = "https://github.com/kpcyrd/sn0int";
    changelog = "https://github.com/kpcyrd/sn0int/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [
      fab
      xrelkd
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "sn0int";
  };
}
