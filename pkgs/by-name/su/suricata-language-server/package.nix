{
  lib,
  python3Packages,
  fetchFromGitHub,
  suricata,
}:

python3Packages.buildPythonApplication rec {
  pname = "suricata-language-server";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StamusNetworks";
    repo = "suricata-language-server";
    tag = "v${version}";
    hash = "sha256-4V98VHe44hBPjJ7uZuVXr7QMmeS6C6mgeJH2ZYQ1nPk=";
  };

  build-system = [ python3Packages.setuptools ];

  propagatedBuildInputs = [ suricata ];

  meta = {
    description = "Implementation of the Language Server Protocol for Suricata signatures";
    homepage = "https://github.com/StamusNetworks/suricata-language-server";
    changelog = "https://github.com/StamusNetworks/suricata-language-server/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ erdnaxe ];
    mainProgram = "suricata-language-server";
  };
}
