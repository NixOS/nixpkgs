{
  lib,
  fetchPypi,
  gitUpdater,
  python3Packages,
  testers,
}:

let
  self = python3Packages.buildPythonApplication {
    pname = "revup";
    version = "0.3.0";
    pyproject = true;

    src = fetchPypi {
      inherit (self) pname version;
      hash = "sha256-LrSRcnWc4AvWbpSrOLprs+rVM0sR1joLat3g9og6BwE=";
    };

    nativeBuildInputs = with python3Packages; [
      pip
      setuptools
      wheel
    ];

    propagatedBuildInputs = with python3Packages; [
      aiohttp
      aiosignal
      async-lru
      async-timeout
      charset-normalizer
      multidict
      requests
      rich
      yarl
    ];

    nativeCheckInputs = with python3Packages; [
      pytest
    ];

    passthru = {
      updateScript = gitUpdater { };
      tests.version = testers.testVersion {
        package = self;
      };
    };

    meta = {
      homepage = "https://github.com/Skydio/revup";
      description = "Efficient git workflow and code review toolkit";
      longDescription = ''
        Revup provides command-line tools that allow developers to iterate
        faster on parallel changes and reduce the overhead of creating and
        maintaining code reviews.

        Features:

        - Revup creates multiple independent chains of branches for you in the
          background and without touching your working tree. It then creates and
          manages github pull requests for all those branches.
        - Pull requests target the actual base branch and can be merged manually
          or by continuous integration
        - Rebase detection saves time and continuous integration cost by not
          re-pushing if the patch hasn't changed
        - Adds reviewers, labels, and creates drafts all from the commit text
        - Adds auto-updating "review graph" and "patchsets" elements to make
          pull requests easier to navigate
        - revup amend and revup restack save time by replacing slow rebases
      '';
      license = lib.licenses.mit;
      mainProgram = "revup";
      maintainers = [ ];
    };
  };
in
self
