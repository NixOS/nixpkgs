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
  setuptools-scm,
}:

let
  version = "0.77.5";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "todo.sr.ht";
    rev = version;
    hash = "sha256-P+ypiW3GHoMClBmW5lUNAG6/sydHHnFGyGajmC3WARg=";
  };

  patches = [ ./patches/core-go-update/todo/patch-deps.patch ];

  todosrht-api = buildGoModule (
    {
      inherit src version patches;
      pname = "todosrht-api";
      modRoot = "api";
      vendorHash = "sha256-ny6cyUIgmupeU8SFP8+RSQU7DD3Lk+j+mZQBoXKv63I=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version patches;
  pname = "todosrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    alembic
  ];

  env = {
    PKGVER = version;
    SRHT_PATH = "${srht}/${python.sitePackages}/srht";
    PREFIX = placeholder "out";
  };

  postBuild = ''
    make SASSC_INCLUDE=-I${srht}/share/sourcehut/scss/ all-share
  '';

  postInstall = ''
    ln -s ${todosrht-api}/bin/api $out/bin/todo.sr.ht-api
    install -Dm644 schema.sql $out/share/sourcehut/todo.sr.ht-schema.sql
    make install-share
  '';

  # pytest tests fail
  nativeCheckInputs = [
    pytest
    factory-boy
  ];
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
