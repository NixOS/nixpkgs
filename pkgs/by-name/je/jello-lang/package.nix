{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  jellyfish,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "jello-lang";
  version = "0-unstable-2025-01-07";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "codereport";
    repo = "jello";
    rev = "462c48d0613d3ef5e2c2c9771b3db64f0747ac89";
    hash = "sha256-5pyJYV6UITtsjHUsyqdiyTXw3dK1ibZQpi8Z3E/L+xo=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/codereport/jello/pull/43
      url = "https://github.com/codereport/jello/commit/16ea477b302a810d161303539c4145130b90544c.patch";
      hash = "sha256-6ZbytV6jUPAoPbV4IAbP5YsgPcjZZ+chGo3Z1h3hg1E=";
    })
  ];

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.colorama
    python3Packages.prompt-toolkit
  ];

  # there are no tests
  doCheck = false;

  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ jellyfish ]}" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Wrapper for Jellyfish (a fork of the Jelly programming language)";
    homepage = "https://github.com/codereport/jello";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "jello";
  };
}
