{ lib
, rustPlatform
, fetchFromGitHub
, python3
, strace
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "shh";
  version = "2023.12.16";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JA6TMxJ4aZYEFCnmO4/ARfA1nhgo98ZPVTdopTGPTK0=";
  };

  cargoHash = "sha256-/K5IFr97CV+T4oD1h6eEb2xGhiuMNS9esLaKt+m4V84=";

  patches = [ ./fix_run_checks.patch ];

  nativeCheckInputs = [ python3 strace systemd ];

  meta = with lib; {
    description = "Automatic systemd service hardening guided by strace profiling";
    homepage = "https://github.com/synacktiv/shh";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "shh";
    maintainers = with maintainers; [ erdnaxe ];
  };
}
