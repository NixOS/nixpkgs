{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  testers,
  backblaze-b2,
  # executable is renamed to backblaze-b2 by default, to avoid collision with boost's 'b2'
  execName ? "backblaze-b2",
}:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "refs/tags/v${version}";
    hash = "sha256-a0XJq8M1yw4GmD5ndIAJtmHFKqS0rYdvYIxK7t7oyZw=";
  };

  nativeBuildInputs = with python3Packages; [
    installShellFiles
    argcomplete
  ];

  build-system = with python3Packages; [
    pdm-backend
  ];

  dependencies = with python3Packages; [
    argcomplete
    arrow
    b2sdk
    phx-class-registry
    docutils
    rst2ansi
    tabulate
    tqdm
    platformdirs
    packaging
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    backoff
    more-itertools
    pexpect
    pytestCheckHook
    pytest-xdist
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Test requires network
    "test/integration/test_b2_command_line.py"
    "test/integration/test_tqdm_closer.py"
    # it's hard to make it work on nix
    "test/integration/test_autocomplete.py"
    "test/unit/test_console_tool.py"
    # this one causes successive tests to fail
    "test/unit/_cli/test_autocomplete_cache.py"
  ];

  disabledTests = [
    # Autocomplete is not successful in a sandbox
    "test_autocomplete_installer"
    "test_help"
    "test_install_autocomplete"
  ];

  postInstall =
    lib.optionalString (execName != "b2") ''
      mv "$out/bin/b2" "$out/bin/${execName}"
    ''
    + ''
      installShellCompletion --cmd ${execName} \
        --bash <(register-python-argcomplete ${execName}) \
        --zsh <(register-python-argcomplete ${execName})
    '';

  passthru.tests.version =
    (testers.testVersion {
      package = backblaze-b2;
      command = "${execName} version --short";
    }).overrideAttrs
      (old: {
        # workaround the error: Permission denied: '/homeless-shelter'
        # backblaze-b2 fails to create a 'b2' directory under the XDG config path
        preHook = ''
          export HOME=$(mktemp -d)
        '';
      });

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
    changelog = "https://github.com/Backblaze/B2_Command_Line_Tool/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka ];
    mainProgram = "backblaze-b2";
  };
}
