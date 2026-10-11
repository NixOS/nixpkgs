{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "rofi-firefox-bookmarks";
  version = "0.1.0";
  pyproject = true;
  build-system = [
    python3Packages.setuptools
  ];

  src = fetchFromGitHub {
    owner = "azban";
    repo = "rofi-firefox-bookmarks";
    tag = "v${version}";
    hash = "sha256-tGuBNxGri1jUYgNRaOqvF7x0PuEmiDH5zjn0o73eJ/E=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/azban/rofi-firefox-bookmarks";
    description = "Rofi script to search and open Firefox bookmarks";
    maintainers = with lib.maintainers; [ azban ];
    license = lib.licenses.mit;
    mainProgram = "rofi-firefox-bookmarks";
  };
}
