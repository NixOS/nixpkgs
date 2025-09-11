{
  lib,
  python3Packages,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
}:

python3Packages.buildPythonApplication rec {
  pname = "lintrunner";
  version = "0.12.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suo";
    repo = "lintrunner";
    rev = "main";
    hash = "sha256-/kNySvqCwfWPRITJEZ+8akQa+ZW7gfo2aOGDyvsRs9E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-+ZuOWIbN5+ZfzpMu5AC449sXrC3ohw1+tNb681VgCww=";
  };

  # Adding maturninBuildHook will automatically build and install the executable
  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  build-system = [ rustPlatform.maturinBuildHook ];

  meta = {
    description = "Tool that runs linters";
    longDescription = ''
      Runs linters by deciding which files need to be linted, invoking linters
      according to a common protocol, and gathering results and presenting them
      to users.
    '';
    homepage = "https://github.com/suo/lintrunner";
    changelog = "https://github.com/suo/lintrunner/releases/tag/v${version}";
    mainProgram = "lintrunner";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prestonhager ];
  };
}
