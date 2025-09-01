{
  lib,
  fetchFromGitHub,
  python3,
  qtbase,
  qtsvg,
  qtwayland,
  nixosTests,
  wrapQtAppsHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "maestral-qt";
  version = "1.9.4";
  pyproject = true;

  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-qt";
    tag = "v${version}";
    hash = "sha256-VkJOKKYnoXux3WjD1JwINGWwv1SMIXfidyV2ITE7dJc=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    click
    markdown2
    maestral
    packaging
    pyqt6
  ];

  buildInputs = [
    qtwayland
    qtbase
    qtsvg # Needed for the systray icon
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  dontWrapQtApps = true;

  makeWrapperArgs = with python3.pkgs; [
    # Firstly, add all necessary QT variables
    "\${qtWrapperArgs[@]}"

    # Add the installed directories to the python path so the daemon can find them
    "--prefix PYTHONPATH : ${makePythonPath (requiredPythonModules maestral.propagatedBuildInputs)}"
    "--prefix PYTHONPATH : ${makePythonPath [ maestral ]}"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/icons/hicolor/512x512/apps src/maestral_qt/resources/maestral.png
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "maestral_qt" ];

  passthru.tests.maestral = nixosTests.maestral;

  meta = {
    description = "GUI front-end for maestral (an open-source Dropbox client) for Linux";
    homepage = "https://maestral.app";
    changelog = "https://github.com/samschott/maestral/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      peterhoeg
      sfrijters
    ];
    platforms = lib.platforms.linux;
    mainProgram = "maestral_qt";
  };
}
