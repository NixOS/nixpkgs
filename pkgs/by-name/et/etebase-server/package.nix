{
  lib,
  fetchFromGitHub,
  python3,
  withLdap ? false,
  withPostgres ? true,
  nix-update-script,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "etebase-server";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "server";
    rev = "refs/tags/v${version}";
    hash = "sha256-W2u/d8X8luOzgy1CLNgujnwaoO1pR1QO1Ma7i4CGkdU=";
  };

  patches = [ ./secret.patch ];

  doCheck = false;

  propagatedBuildInputs =
    with python3.pkgs;
    [
      aiofiles
      django_4
      fastapi
      msgpack
      pynacl
      redis
      uvicorn
      websockets
      watchfiles
      uvloop
      pyyaml
      python-dotenv
      httptools
      typing-extensions
    ]
    ++ lib.optional withLdap python-ldap
    ++ lib.optional withPostgres psycopg2;

  postInstall = ''
    mkdir -p $out/bin $out/lib
    cp manage.py $out/bin/etebase-server
    wrapProgram $out/bin/etebase-server --prefix PYTHONPATH : "$PYTHONPATH"
    chmod +x $out/bin/etebase-server
  '';

  passthru.updateScript = nix-update-script { };
  passthru.python = python3;
  # PYTHONPATH of all dependencies used by the package
  passthru.pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;
  passthru.tests = {
    nixosTest = nixosTests.etebase-server;
  };

  meta = with lib; {
    homepage = "https://github.com/etesync/server";
    description = "Etebase (EteSync 2.0) server so you can run your own";
    mainProgram = "etebase-server";
    changelog = "https://github.com/etesync/server/blob/${version}/ChangeLog.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      felschr
      phaer
    ];
  };
}
