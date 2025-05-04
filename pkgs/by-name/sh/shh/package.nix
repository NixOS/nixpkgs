{
  lib,
  rustPlatform,
  fetchFromGitHub,
  python3,
  strace,
  systemd,
  iproute2,
}:

rustPlatform.buildRustPackage rec {
  pname = "shh";
  version = "2025.4.12";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "shh";
    tag = "v${version}";
    hash = "sha256-+JWz0ya6gi8pPERnpAcQIe7zZUzWGxha+9/gizMVtEw=";
  };

  cargoHash = "sha256-TdP+1sb1GEFM57z+rc+gqhoWQhPAXzvMt/FCWf3wpr8=";

  patches = [
    ./fix_run_checks.patch
    ./pr13-profile-path-fix-strace.patch
  ];

  # buildFeatures = [ /*"gen-man-pages"*/ ];

  checkFeatures = [ "nix-build-env" ];

  buildInputs = [
    strace
    systemd
  ];

  nativeCheckInputs = [
    strace
    systemd
    python3
    iproute2
  ];

  # RUST_BACKTRACE = 1;

  meta = {
    description = "Automatic systemd service hardening guided by strace profiling";
    homepage = "https://github.com/desbma/shh";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "shh";
    maintainers = with lib.maintainers; [
      erdnaxe
      kuflierl
    ];
  };
}
