{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "command-injection-tester";
  version = "0.0.2-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "Email-Analysis-Toolkit";
    repo = "command-injection-tester";
    rev = "dbcf85f7fdb173028a8af461e2c0f8bfcac42b73";
    hash = "sha256-g7FyyzpY4rJ9DHDamqUPq4gIUJE3ZUXfxP1ydmm9y+E=";
  };

  build-system = [ python3Packages.setuptools ];

  meta = {
    description = "Test mail servers for STARTTLS command injection vulnerability";
    homepage = "https://github.com/Email-Analysis-Toolkit/command-injection-tester";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mib ];
    mainProgram = "command-injection-tester";
  };
}
