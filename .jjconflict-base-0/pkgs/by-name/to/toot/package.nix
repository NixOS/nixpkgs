{
  lib,
  fetchFromGitHub,
  python3Packages,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.47.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "toot";
    rev = "refs/tags/${version}";
    hash = "sha256-TG98e/3X+bcNsx8ZR0Nv0VWlR/cJ7tzz46K7tYyoKsM=";
  };

  nativeCheckInputs = with python3Packages; [ pytest ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    requests
    beautifulsoup4
    wcwidth
    urwid
    urwidgets
    tomlkit
    click
    pillow
    term-image
  ];

  checkPhase = ''
    runHook preCheck
    py.test
    runHook postCheck
  '';

  passthru.tests.toot = nixosTests.pleroma;

  meta = {
    description = "Mastodon CLI interface";
    mainProgram = "toot";
    homepage = "https://github.com/ihabunek/toot";
    changelog = "https://github.com/ihabunek/toot/blob/refs/tags/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      aleksana
    ];
  };
}
