{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ghunt";
  version = "2.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mxrch";
    repo = "ghunt";
    # The newer releases aren't git-tagged to we just take the
    # commit with the version bump
    rev = "e8b0669cabb410dc40fb76b8d5d386a3a83fe08c";
    hash = "sha256-Zd0kpyr+Hkbh5MH3q3lrkH3liXw95sKRX+SZhsUVUhI=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      alive-progress
      autoslot
      beautifulsoup4
      beautifultable
      dnspython
      geopy
      httpx
      humanize
      imagehash
      inflection
      jsonpickle
      pillow
      protobuf
      python-dateutil
      rich
      rich-argparse
      packaging
    ]
    ++ httpx.optional-dependencies.http2;

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ghunt"
  ];

  meta = {
    description = "Offensive Google framework";
    mainProgram = "ghunt";
    homepage = "https://github.com/mxrch/ghunt";
    changelog = "https://github.com/mxrch/GHunt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
