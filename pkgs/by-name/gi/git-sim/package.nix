{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  addBinToPathHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-sim";
  version = "0.3.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "initialcommit-com";
    repo = "git-sim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4jHkAlF2SAzHjBi8pmAJ0TKkcLxw+6EdGsXnHZUMILw=";
  };

  patches = [ ./tests.patch ];

  build-system = with python3Packages; [ setuptools ];

  pythonRemoveDeps = [ "opencv-python-headless" ];

  dependencies = with python3Packages; [
    gitpython
    manim
    opencv4
    typer
    pydantic
    fonttools
    git-dummy
  ];

  # https://github.com/NixOS/nixpkgs/commit/8033561015355dd3c3cf419d81ead31e534d2138
  makeWrapperArgs = [
    "--prefix"
    "PYTHONWARNINGS"
    ","
    "ignore:::pydub.utils:"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    # https://github.com/NixOS/nixpkgs/issues/308283
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      # Otherwise, typer ignores the requested shell and instead detects it by walking the
      # process tree, which yields bash on linux and fails outright on darwin:
      # https://github.com/fastapi/typer/blob/0.25.1/typer/completion.py#L42-L59
      ''
        export _TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1
        installShellCompletion --cmd git-sim \
          --bash <($out/bin/git-sim --show-completion bash) \
          --fish <($out/bin/git-sim --show-completion fish) \
          --zsh <($out/bin/git-sim --show-completion zsh)
      ''
    + ''
      ln -s ${lib.getExe python3Packages.git-dummy} $out/bin/
    '';

  nativeCheckInputs = [
    addBinToPathHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    git-dummy
  ]);

  doCheck = false;

  meta = {
    description = "Visually simulate Git operations in your own repos with a single terminal command";
    homepage = "https://initialcommit.com/tools/git-sim";
    changelog = "https://github.com/initialcommit-com/git-sim/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mathiassven ];
  };
})
