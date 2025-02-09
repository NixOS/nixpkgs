{ lib
, stdenv
, python3
, fetchPypi
}:

let
  pname = "revup";
  version = "0.2.1";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EaBI414m5kihuaOkaHYAzvVxeJCgMIh9lD0JnCeVdZM=";
  };
in
python3.pkgs.buildPythonPackage {
  inherit pname version src;

  nativeBuildInputs = with python3.pkgs; [
    pip
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  nativeCheckInputs = with python3.pkgs; [
    pytest
  ];

  meta = {
    homepage = "https://github.com/Skydio/revup";
    description = " Revolutionary github tools";
    longDescription = ''
      Revup provides command-line tools that allow developers to iterate faster
      on parallel changes and reduce the overhead of creating and maintaining
      code reviews.

      Features:

      - Revup creates multiple independent chains of branches for you in the
        background and without touching your working tree. It then creates and
        manages github pull requests for all those branches.
      - Pull requests target the actual base branch and can be merged manually
        or by continuous integration
      - Rebase detection saves time and continuous integration cost by not
        re-pushing if the patch hasn't changed
      - Adds reviewers, labels, and creates drafts all from the commit text
      - Adds auto-updating "review graph" and "patchsets" elements to make pull
        requests easier to navigate revup amend and revup restack save time by
        replacing slow rebases
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "revup";
  };
}
