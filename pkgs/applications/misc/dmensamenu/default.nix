{ stdenv, buildPythonApplication, fetchFromGitHub, requests, dmenu }:

buildPythonApplication rec {
  name = "dmensamenu-${version}";
  version = "1.0.0";

  propagatedBuildInputs = [
    requests
    dmenu
  ];

  src = fetchFromGitHub {
    owner = "dotlambda";
    repo = "dmensamenu";
    rev = "v${version}";
    sha256 = "05wbpmgjpm0ik9pcydj7r9w7i7bfpcij24bc4jljdwl9ilw62ixp";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/dotlambda/dmensamenu;
    description = "Print German canteen menus using dmenu and OpenMensa";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
