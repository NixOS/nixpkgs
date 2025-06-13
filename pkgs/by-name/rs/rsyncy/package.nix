{
  lib,
  fetchFromGitHub,
  python3Packages,
  rsync,
}:

python3Packages.buildPythonApplication rec {
  pname = "rsyncy";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "laktak";
    repo = "rsyncy";
    tag = "v${version}";
    hash = "sha256-aGwHR72oY5EjrfIdBKWgcHY8k0d+3zi+OWz1uNXAh5U=";
  };

  build-system = with python3Packages; [ setuptools ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ rsync ]}"
  ];

  meta = {
    description = "Progress bar wrapper for rsync";
    homepage = "https://github.com/laktak/rsyncy";
    changelog = "https://github.com/laktak/rsyncy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "rsyncy";
  };
}
