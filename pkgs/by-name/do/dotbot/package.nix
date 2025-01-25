{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "dotbot";
  version = "1.20.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anishathalye";
    repo = "dotbot";
    tag = "v${version}";
    hash = "sha256-GnzN8z7LP9rVD0DnKkPxJ0BxiO1YDY7MyMWBt1CAh6g=";
  };

  preCheck = ''
    patchShebangs bin/dotbot
  '';

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [ pyyaml ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = {
    description = "Tool that bootstraps your dotfiles";
    mainProgram = "dotbot";
    longDescription = ''
      Dotbot is designed to be lightweight and self-contained, with no external
      dependencies and no installation required. Dotbot can also be a drop-in
      replacement for any other tool you were using to manage your dotfiles, and
      Dotbot is VCS-agnostic -- it doesn't make any attempt to manage your
      dotfiles.
    '';
    homepage = "https://github.com/anishathalye/dotbot";
    changelog = "https://github.com/anishathalye/dotbot/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ludat ];
  };
}
