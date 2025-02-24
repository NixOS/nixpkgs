{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
}:

python3Packages.buildPythonApplication rec {
  pname = "ibus-theme-tools";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "IBus-Theme-Tools";
    rev = "v${version}";
    sha256 = "0i8vwnikwd1bfpv4xlgzc51gn6s18q58nqhvcdiyjzcmy3z344c2";
  };

  buildInputs = [ gettext ];

  propagatedBuildInputs = with python3Packages; [
    tinycss2
    pygobject3
  ];

  # No test.
  doCheck = false;

  pythonImportsCheck = [ "ibus_theme_tools" ];

  meta = with lib; {
    description = "Generate the IBus GTK or GNOME Shell theme from existing themes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];
    homepage = "https://github.com/openSUSE/IBus-Theme-Tools";
    mainProgram = "ibus-theme-tools";
  };
}
