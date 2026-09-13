{
  lib,
  python3Packages,
  fetchFromGitLab,
}:

python3Packages.buildPythonApplication {
  pname = "moz-idb-edit";
  version = "0-unstable-2025-10-13";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ntninja";
    repo = "moz-idb-edit";
    rev = "e008c289609138b6c575357b9889c0aa0ed14f07";
    hash = "sha256-4Ddfv+MZ146mQo7zOPwcmf/gUTEB4usJWjHf6y2KZ5E=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    cramjam
    jmespath
  ];

  pythonImportsCheck = [ "mozidbedit" ];

  meta = {
    description = "IndexedDB reader for Firefox and other MozTK applications";
    homepage = "https://gitlab.com/ntninja/moz-idb-edit";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jakehpark ];
    mainProgram = "moz-idb-edit";
  };
}
