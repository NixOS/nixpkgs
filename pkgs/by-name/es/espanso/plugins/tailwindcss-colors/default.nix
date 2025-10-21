{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "tailwindcss-colors";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package that provides TailwindCSS's default color palette as hex color codes for quick access.";
    homepage = "https://github.com/paulinek13/espanso-hub/blob/main/packages/tailwindcss-colors/0.1.1/README.md";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
