{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  python,
  unzip,
  pythonOlder,
  setuptools-scm,
}:

let
  version = "0.84.2";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
    generatePaths = [
      "./api/loaders"
      "./api/graph"
    ];
  };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "todo.sr.ht";
    rev = version;
    hash = "sha256-KKyUaKdGtQomWDxwdViTi3MiXLwmFCDvBX+M9nVpt9A=";
  };

  todosrht-api = buildGoModule (
    {
      inherit src version;
      pname = "todosrht-api";
      vendorHash = "sha256-kPi5iX+dX1jHoPt4tSFwtVkwg/2+LMJUNVtGCtBle8Q=";
      env.PKGVER = version;
      subPackages = [ "./cmd/api" ];
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "todosrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
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

  pythonImportsCheck = [ "todosrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/todo.sr.ht";
    description = "Ticket tracking service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
