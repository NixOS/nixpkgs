{
  lib,
  fetchFromGitHub,
  python3Packages,
  gitUpdater,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mbuild";
  version = "2026.08.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intelxed";
    repo = "mbuild";
    tag = "v${finalAttrs.version}";
    hash = "sha256-neccoffjGqXaund9QVo8CeI3QPn/ZB/EPLVZCN/wWTY=";
  };

  build-system = with python3Packages; [ setuptools ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Python-based build system used for building XED";
    homepage = "https://github.com/intelxed/mbuild";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
