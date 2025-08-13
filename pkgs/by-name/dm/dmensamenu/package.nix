{
  lib,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  dmenu,
}:

python3Packages.buildPythonApplication rec {
  pname = "dmensamenu";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dotlambda";
    repo = "dmensamenu";
    tag = version;
    hash = "sha256-dtQpNDhw1HklEtltYl3yiz54UDLOJWJHNZEuQGaIYbI=";
  };

  patches = [
    (replaceVars ./dmenu-path.patch {
      inherit dmenu;
    })
  ];

  dependencies = with python3Packages; [
    requests
  ];

  # No tests implemented
  doCheck = false;

  meta = {
    homepage = "https://github.com/dotlambda/dmensamenu";
    description = "Print German canteen menus using dmenu and OpenMensa";
    mainProgram = "dmensamenu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
