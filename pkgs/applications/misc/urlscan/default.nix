{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = version;
    sha256 = "sha256-KQXEiDg5KRCMFFyDlR8D6CQTxRdIZx4/U1csTFCr0sU=";
  };

  propagatedBuildInputs = [
    python3Packages.urwid
  ];

  doCheck = false; # No tests available

  pythonImportsCheck = [ "urlscan" ];

  meta = with lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = "https://github.com/firecat53/urlscan";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dpaetzel jfrankenau ];
  };
}
