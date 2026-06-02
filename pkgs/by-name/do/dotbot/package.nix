{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dotbot";
  version = "1.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anishathalye";
    repo = "dotbot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HlCq9ek/419A+bgwtbRr45Q2RqPPv38QKSV+CwzihFc=";
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
    changelog = "https://github.com/anishathalye/dotbot/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ludat ];
  };
})
