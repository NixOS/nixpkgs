{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
  nixosTests,
  seafile-server,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "seahub";
  version = "12.0.11";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "cd9cedbeb337a7503098bf627214e88a84d0c63e"; # using a fixed revision because upstream may re-tag releases :/
    hash = "sha256-mXaehtgj9vwTjvR3zUR0ButCtFuZAojXYRq9HEJIMfo=";
  };

  dontBuild = true;

  doCheck = false; # disabled because it requires a ccnet environment

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3.pkgs; [
    django
    future
    django-compressor
    django-statici18n
    django-webpack-loader
    django-simple-captcha
    django-picklefield
    django-formtools
    djangosaml2
    mysqlclient
    pillow
    python-dateutil
    djangorestframework
    openpyxl
    requests
    requests-oauthlib
    chardet
    pyjwt
    pycryptodome
    # The correct version of pyopenssl is transitively provided by djangosaml2 -> pysaml2 -> pyopenssl
    python-ldap
    qrcode
    pysearpc
    gunicorn
    markdown
    bleach

    (python3.pkgs.toPythonModule (seafile-server.override { inherit python3; }))
  ];

  postPatch = ''
    substituteInPlace seahub/settings.py --replace-fail "SEAFILE_VERSION = '6.3.3'" "SEAFILE_VERSION = '${version}'"
  '';

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:"
  '';

  passthru = {
    inherit python3;
    pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;
    tests = {
      inherit (nixosTests) seafile;
    };
    inherit seafile-server;
  };

  meta = with lib; {
    description = "Web end of seafile server";
    homepage = "https://github.com/haiwen/seahub";
    license = licenses.asl20;
    maintainers = with maintainers; [
      greizgh
      schmittlauch
      melvyn2
    ];
    platforms = platforms.linux;
  };
}
