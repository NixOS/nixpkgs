{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "rmview";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "bordaigorl";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zyngirpg808k1pkyhrk43qr3i8ilvfci0wzwk4b5f6f9cmjs7kb";
  };

  nativeBuildInputs = with python3Packages; [ pyqt5 wrapQtAppsHook ];
  propagatedBuildInputs = with python3Packages; [ pyqt5 paramiko twisted ];

  preBuild = ''
    pyrcc5 -o src/rmview/resources.py resources.qrc
  '';

  preFixup = ''
    wrapQtApp "$out/bin/rmview"
  '';

  meta = with lib; {
    description = "Fast live viewer for reMarkable 1 and 2";
    homepage = "https://github.com/bordaigorl/rmview";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.nickhu ];
  };
}
