{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "openttd-nml";
  version = "0.9.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    tag = finalAttrs.version;
    hash = "sha256-FVGjXh04uHZM9vZNzjdYEk4ClMR9t0kl44JePrUGx84=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  postPatch = ''
    echo 'version = "${finalAttrs.version}"' > nml/__version__.py

    # Ply's source code is vendored.
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools", "ply"' '"setuptools"'
  '';

  dependencies = [
    python3Packages.pillow
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  installCheckPhase = ''
    runHook preInstallCheck

    export PYTHON=${python3Packages.python}/bin/python
    export NMLC=$out/bin/nmlc

    make regression

    runHook postInstallCheck
  '';

  meta = {
    changelog = "https://github.com/OpenTTD/nml/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/OpenTTD/nml";
    description = "Compiler for OpenTTD NML files";
    mainProgram = "nmlc";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magicquark ];
  };
})
