{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "rmview";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "bordaigorl";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-oCF37WQqNIXut2k+xr528twGxwPoH/sQ2leThagQJAU=";
  };

  nativeBuildInputs = with python3Packages; [ pyqt5 wrapQtAppsHook ];
  propagatedBuildInputs = with python3Packages; [ pyqt5 paramiko twisted pyjwt pyopenssl service-identity sshtunnel ];

  preBuild = ''
    pyrcc5 -o src/rmview/resources.py resources.qrc
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Fast live viewer for reMarkable 1 and 2";
    homepage = "https://github.com/bordaigorl/rmview";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.nickhu ];
  };
}
