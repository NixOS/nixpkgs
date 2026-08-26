{
  lib,
  fetchFromGitLab,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gradlew-fdroid";
  version = "0-unstable-2026-06-06";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "gradlew-fdroid";
    rev = "9f31b7ee881e46a5d7d234406c14e5e474bc5fc4";
    hash = "sha256-ONBoQBgkWY0hfRy5Qlz87eYG5ORcI1XEDGTY4oKu5HE=";
  };

  build-system = [ python3Packages.hatchling ];

  # The test suite downloads and executes Gradle distributions.
  doCheck = false;

  nativeBuildInputs = [
    # needed for importing gradlew
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "gradlew" ];

  meta = {
    description = "Reimplementation of the Gradle wrapper script";
    homepage = "https://gitlab.com/fdroid/gradlew-fdroid";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ linsui ];
    mainProgram = "gradlew-fdroid";
  };
})
