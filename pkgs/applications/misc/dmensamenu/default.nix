{ stdenv, buildPythonApplication, fetchFromGitHub, requests, dmenu }:

buildPythonApplication rec {
  name = "dmensamenu-${version}";
  version = "1.1.1";

  propagatedBuildInputs = [
    requests
    dmenu
  ];

  src = fetchFromGitHub {
    owner = "dotlambda";
    repo = "dmensamenu";
    rev = version;
    sha256 = "0gc23k2zbv9zfc0v27y4spiva8cizxavpzd5pch5qbawh2lak6a3";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/dotlambda/dmensamenu;
    description = "Print German canteen menus using dmenu and OpenMensa";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
