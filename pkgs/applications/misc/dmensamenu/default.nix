{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  substituteAll,
  requests,
  dmenu,
}:

buildPythonApplication rec {
  pname = "dmensamenu";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "dotlambda";
    repo = "dmensamenu";
    rev = version;
    sha256 = "1ck1i1k40bli6m3n49ff6987hglby9fn4vfr28jpkm3h70s2km3n";
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

  meta = with lib; {
    homepage = "https://github.com/dotlambda/dmensamenu";
    description = "Print German canteen menus using dmenu and OpenMensa";
    mainProgram = "dmensamenu";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
