{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  alembic,
  pytest,
  factory-boy,
  python,
  unzip,
  pythonOlder,
  setuptools,
}:

let
  version = "0.75.10";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.45";
  };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "todo.sr.ht";
    rev = version;
    hash = "sha256-3dVZdupsygM7/6T1Mn7yRc776aa9pKgwF0hgZX6uVQ0=";
  };

  todosrht-api = buildGoModule (
    {
      inherit src version;
      pname = "todosrht-api";
      modRoot = "api";
      vendorHash = "sha256-fImOQLnQLHTrg5ikuYRZ+u+78exAiYA19DGQoUjQBOM=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "todosrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    srht
    alembic
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    ln -s ${todosrht-api}/bin/api $out/bin/todosrht-api
  '';

  # pytest tests fail
  nativeCheckInputs = [
    pytest
    factory-boy
  ];

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "todosrht" ];

  meta = with lib; {
    homepage = "https://todo.sr.ht/~sircmpwn/todo.sr.ht";
    description = "Ticket tracking service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
