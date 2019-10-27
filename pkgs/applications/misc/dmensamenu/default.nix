{ stdenv, buildPythonApplication, fetchFromGitHub, substituteAll, requests, dmenu }:

buildPythonApplication rec {
  pname = "dmensamenu";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "dotlambda";
    repo = "dmensamenu";
    rev = version;
    sha256 = "15c8g2vdban3dw3g979icypgpx52irpvv39indgk19adicgnzzqp";
  };

  patches = [
    (substituteAll {
      src = ./dmenu-path.patch;
      inherit dmenu;
    })
  ];

  propagatedBuildInputs = [
    requests
  ];

  # No tests implemented
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/dotlambda/dmensamenu;
    description = "Print German canteen menus using dmenu and OpenMensa";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
