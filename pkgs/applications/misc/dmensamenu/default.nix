{ stdenv, buildPythonApplication, fetchFromGitHub, requests, dmenu }:

buildPythonApplication rec {
  name = "dmensamenu-${version}";
  version = "1.1.0";

  propagatedBuildInputs = [
    requests
    dmenu
  ];

  src = fetchFromGitHub {
    owner = "dotlambda";
    repo = "dmensamenu";
    rev = version;
    sha256 = "126gidid53blrpfq1vd85iim338qrk7n8r4nyhh2hvsi7cfaab1y";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/dotlambda/dmensamenu;
    description = "Print German canteen menus using dmenu and OpenMensa";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
