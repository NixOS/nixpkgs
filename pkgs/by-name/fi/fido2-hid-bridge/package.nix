{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "fido2-hid-bridge";
  version = "0.1.0-unstable-2026-06-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BryanJacobs";
    repo = "fido2-hid-bridge";
    rev = "1f3cad668a37105ea7db484f2f15af88617fa5a7";
    hash = "sha256-DWxnMhGEfH/hDriFKZB3j4tImPUvKq2npG1ulf/Q2wo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  build-system = with python3Packages; [ poetry-core ];
  dependencies =
    with python3Packages;
    (
      [
        uhid
        fido2
        pyscard
      ]
      ++ fido2.optional-dependencies.pcsc
    );

  doCheck = false;

  dontCheckRuntimeDeps = true; # pyinstaller version is out of date

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "HID to PC/SC bridge allowing browsers to use FIDO2 smartcards";
    homepage = "https://github.com/BryanJacobs/fido2-hid-bridge";
    license = lib.licenses.mit;
    mainProgram = "fido2-hid-bridge";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
