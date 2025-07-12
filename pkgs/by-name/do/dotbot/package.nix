{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "dotbot";
  version = "1.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anishathalye";
    repo = "dotbot";
    tag = "v${version}";
    hash = "sha256-3U8lIsqy95Ulxa5f2hHGFmuAqQ7WZtikvgaplX6GTF0=";
  };

  preCheck = ''
    patchShebangs bin/dotbot
  '';

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [ pyyaml ];

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
    changelog = "https://github.com/anishathalye/dotbot/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ludat ];
  };
}
