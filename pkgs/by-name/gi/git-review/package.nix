{
  lib,
  python3Packages,
  fetchgit,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-review";
  version = "2.5.0";
  format = "setuptools";

  # Manually set version because pbr wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = version;

  # fetchFromGitea fails trying to download archive file
  src = fetchgit {
    url = "https://opendev.org/opendev/git-review";
    tag = version;
    hash = "sha256-RE5XAUS46Y/jtI0/csR59B9l1gYpHuwGQkbWqoTfxPk=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = with python3Packages; [
    pbr
  ];

  dependencies = with python3Packages; [
    requests
    setuptools # implicit dependency, used to get package version through pkg_resources
  ];

  # Don't run tests because they pull in external dependencies
  # (a specific build of gerrit + maven plugins), and I haven't figured
  # out how to work around this yet.
  doCheck = false;

  pythonImportsCheck = [ "git_review" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Tool to submit code to Gerrit";
    homepage = "https://opendev.org/opendev/git-review";
    changelog = "https://docs.opendev.org/opendev/git-review/latest/releasenotes.html#relnotes-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kira-bruneau ];
    mainProgram = "git-review";
  };
}
