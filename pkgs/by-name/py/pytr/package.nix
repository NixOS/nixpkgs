{
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "pytr";
<<<<<<< HEAD
  version = "0.4.5";
=======
  version = "0.4.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytr-org";
    repo = "pytr";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VfNoovNGvu1tNbYYiIX8KTOfll0WrHxJsLk/Yoyhu6s=";
=======
    hash = "sha256-72CxtO9AvjgK0lwcjHZexfedpNbrFEvRSN30hhiv+Zk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3Packages; [
    hatchling
    hatch-babel
  ];

  dependencies = with python3Packages; [
    babel
    certifi
    coloredlogs
    ecdsa
    packaging
    pathvalidate
    pygments
    requests-futures
    shtab
    websockets
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pytr \
      --bash <($out/bin/pytr completion bash) \
      --zsh <($out/bin/pytr completion zsh)
  '';

  nativeCheckInputs = [
    versionCheckHook
    python3Packages.pytestCheckHook
  ];

<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [ "pytr" ];

  meta = {
    changelog = "https://github.com/pytr-org/pytr/releases/tag/${src.tag}";
    description = "Use TradeRepublic in terminal and mass download all documents";
    homepage = "https://github.com/pytr-org/pytr";
    license = lib.licenses.mit;
    mainProgram = "pytr";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
