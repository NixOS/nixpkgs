{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ouroboros-ai";
  version = "0.51.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Q00";
    repo = "ouroboros";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AhPHsueCU/ZkkHJ+w7nh4cqiWZHbNj1gUU6dE1gv0t0=";
  };

  # The GitHub tarball has no PKG-INFO or .git, so hatch-vcs cannot
  # resolve the version on its own.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3Packages; [
    aiosqlite
    anyio
    click
    jsonschema
    prompt-toolkit
    pydantic
    python-dotenv
    pyyaml
    rich
    sqlalchemy
    structlog
    typer
  ];

  # The test suite drives agent runtimes and writes to a real state directory,
  # so it is not usable in the sandbox. Check the entry points instead.
  doCheck = false;

  pythonImportsCheck = [ "ouroboros" ];

  meta = {
    description = "Specification-first workflow engine that loops AI coding agents until the pinned acceptance spec passes";
    longDescription = ''
      Ouroboros runs a Socratic interview to crystallize vague requirements
      into a pinned acceptance spec, then loops coding agents against it:
      each iteration is generated, independently verified against the spec,
      and re-attempted on failure. The verify command and expected output
      are withheld from the worker contract, so agents cannot overfit to
      the checker.
    '';
    homepage = "https://github.com/Q00/ouroboros";
    changelog = "https://github.com/Q00/ouroboros/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "ouroboros";
    maintainers = with lib.maintainers; [ q00 ];
  };
})
