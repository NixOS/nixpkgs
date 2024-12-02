{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
}:
let
  inherit (python3Packages)
    buildPythonApplication
    gitpython
    manim
    opencv4
    typer
    pydantic
    fonttools
    git-dummy
    pytestCheckHook
    ;

  version = "0.3.5";
in

buildPythonApplication {
  pname = "git-sim";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "initialcommit-com";
    repo = "git-sim";
    rev = "v${version}";
    hash = "sha256-4jHkAlF2SAzHjBi8pmAJ0TKkcLxw+6EdGsXnHZUMILw=";
  };

  patches = [ ./tests.patch ];

  build-system = [ ];

  pythonRemoveDeps = [ "opencv-python-headless" ];

  dependencies = [
    gitpython
    manim
    opencv4
    typer
    pydantic
    fonttools
    git-dummy
  ];

  # https://github.com/NixOS/nixpkgs/commit/8033561015355dd3c3cf419d81ead31e534d2138
  makeWrapperArgs = [ "--prefix PYTHONWARNINGS , ignore:::pydub.utils:" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    # https://github.com/NixOS/nixpkgs/issues/308283
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd git-sim \
        --bash <($out/bin/git-sim --show-completion bash) \
        --fish <($out/bin/git-sim --show-completion fish) \
        --zsh <($out/bin/git-sim --show-completion zsh)
    ''
    + "ln -s ${git-dummy}/bin/git-dummy $out/bin/";

  preCheck = ''
    PATH=$PATH:$out/bin
  '';

  nativeCheckInputs = [
    pytestCheckHook
    git-dummy
  ];

  doCheck = false;

  meta = {
    description = "Visually simulate Git operations in your own repos with a single terminal command";
    homepage = "https://initialcommit.com/tools/git-sim";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mathiassven ];
  };
}
