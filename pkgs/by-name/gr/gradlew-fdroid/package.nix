{
  lib,
  fetchFromGitLab,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "gradlew-fdroid";
  version = "0.0.1-unstable-2026-01-07";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "gradlew-fdroid";
    rev = "996b7829f40f33317d33c1b6ddcffcf976bd6181";
    hash = "sha256-aQoQ1Js5Wqj2Gp10+66c/esdEjrCNYgbh6HYVwhYiEY=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    hatchling
  ];

  meta = {
    homepage = "https://gitlab.com/fdroid/gradlew-fdroid";
    description = "Reimplementation of gradlew script";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ linsui ];
    mainProgram = "gradlew-fdroid";
  };
}
