{
  lib,
  git,
  python3,
  fetchFromGitHub,
  testers,
  git-pw,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "git-pw";
  version = "2.6.0";
  format = "pyproject";

  PBR_VERSION = version;

  src = fetchFromGitHub {
    owner = "getpatchwork";
    repo = "git-pw";
    rev = version;
    hash = "sha256-3IiFU6qGI2MDTBOLQ2qyT5keUMNTNG3sxhtGR3bkIBc=";
  };

  postPatch = ''
    # We don't want to run the coverage.
    substituteInPlace tox.ini --replace "--cov=git_pw --cov-report" ""
  '';

  nativeBuildInputs = with python3.pkgs; [
    pbr
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
    arrow
    click
    requests
    tabulate
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest
    git
  ];

  # This is needed because `git-pw` always rely on an ambiant git.
  # Furthermore, this doesn't really make sense to resholve git inside this derivation.
  # As `testVersion` does not offer the right knob, we can just `overrideAttrs`-it ourselves.
  passthru.tests.version = (testers.testVersion { package = git-pw; }).overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ git ];
  });

  meta = with lib; {
    description = "A tool for integrating Git with Patchwork, the web-based patch tracking system";
    homepage = "https://github.com/getpatchwork/git-pw";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
