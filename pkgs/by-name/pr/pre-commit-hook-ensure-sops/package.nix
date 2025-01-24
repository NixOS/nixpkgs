{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
}:

python3Packages.buildPythonApplication rec {
  pname = "pre-commit-hook-ensure-sops";
  version = "1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "yuvipanda";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8sMmHNzmYwOmHYSWoZ4rKb/2lKziFmT6ux+s+chd/Do=";
  };

  patches = [
    # Add the command-line entrypoint to pyproject.toml
    # Can be removed after v1.2 release that includes changes
    (fetchpatch {
      url = "https://github.com/yuvipanda/pre-commit-hook-ensure-sops/commit/ed88126afa253df6009af7cbe5aa2369f963be1c.patch";
      hash = "sha256-mMxAoC3WEciO799Rq8gZ2PJ6FT/GbeSpxlr1EPj7r4s=";
    })
  ];

  propagatedBuildInputs = [
    python3Packages.ruamel-yaml
  ];

  pythonImportsCheck = [
    "pre_commit_hook_ensure_sops"
  ];

  # Test entrypoint
  checkPhase = ''
    runHook preCheck
    $out/bin/pre-commit-hook-ensure-sops --help
    runHook postCheck
  '';

  meta = with lib; {
    description = "pre-commit hook to ensure that files that should be encrypted with sops are";
    homepage = "https://github.com/yuvipanda/pre-commit-hook-ensure-sops";
    maintainers = with maintainers; [ nialov ];
    license = licenses.bsd3;
    mainProgram = "pre-commit-hook-ensure-sops";
  };
}
