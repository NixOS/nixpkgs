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

  # NOTE: there is a PR open on the upstream repository for the Cargo.lock file.
  # After that is merged we can change the owner and rev to the upstream
  # repository instead of a fork.
  src = fetchFromGitHub {
    owner = "PrestonHager";
    repo = "lintrunner";
    tag = "v${version}";
    hash = "sha256-CYSNEDT9RO7bnVW8zcDDJOva4GOKGMNs1CcU//IbBrc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-dv/CznOB/VFx1PM+cYmdHuiK7d8z/HUQbDt5iy5LUTI=";
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
