{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ibus-theme-tools";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "IBus-Theme-Tools";
    rev = "v${finalAttrs.version}";
    sha256 = "0i8vwnikwd1bfpv4xlgzc51gn6s18q58nqhvcdiyjzcmy3z344c2";
  };

  buildInputs = [ gettext ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    tinycss2
    pygobject3
  ];

  # No test.
  doCheck = false;

  pythonImportsCheck = [ "ibus_theme_tools" ];

  meta = {
    description = "Generate the IBus GTK or GNOME Shell theme from existing themes";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hollowman6 ];
    homepage = "https://github.com/openSUSE/IBus-Theme-Tools";
    mainProgram = "ibus-theme-tools";
  };
})
