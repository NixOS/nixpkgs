{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "polysh";
  version = "1.0.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "innogames";
    repo = "polysh";
    tag = "polysh-${finalAttrs.version}";
    hash = "sha256-t24Z5ftfQwkw9iB6T63kM/Mc9w66Szezig1e5PAlqiQ=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  meta = {
    description = "Remote shell multiplexer for executing commands on multiple hosts";
    homepage = "https://github.com/innogames/polysh";
    changelog = "https://github.com/innogames/polysh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ seqizz ];
    platforms = lib.platforms.unix;
  };
})
