{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gh-profiler";
  version = "0.10.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ehmatthes";
    repo = "gh-profiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OoeU1UXKuYEKreskEldll9O8SrEpjPpZxu51ABXBPJs=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    click
    httpx2
    humanize
    rich
  ];

  pythonImportsCheck = [
    "gh_profiler"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Examine a GH user's profile, to help quickly decide how much to invest in their contributions";
    homepage = "https://github.com/ehmatthes/gh-profiler";
    changelog = "https://github.com/ehmatthes/gh-profiler/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivyxu ];
    mainProgram = "gh-profiler";
  };
})
