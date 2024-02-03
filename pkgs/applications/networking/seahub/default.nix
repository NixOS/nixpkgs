{ lib
, fetchFromGitHub
, fetchpatch
, python3
, makeWrapper
, nixosTests
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_3;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "seahub";
  version = "10.0.2";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "refs/tags/seafile-docs-${version}"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "sha256-X/GsUVJTCPlrKN7fqt7u57U5/huB82cvEjh6MwH81Ac=";
  };

  patches = [
    (fetchpatch {
      # PIL update fix
      url = "https://patch-diff.githubusercontent.com/raw/haiwen/seahub/pull/5570.patch";
      sha256 = "sha256-7V2aRlacJ7Qhdi9k4Bs+t/Emx+EAM/NNCI+K40bMwLA=";
    })
  ];

  dontBuild = true;

  doCheck = false; # disabled because it requires a ccnet environment

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = with python.pkgs; [
    django
    future
    django-compressor
    django-statici18n
    django-webpack-loader
    django-simple-captcha
    django-picklefield
    django-formtools
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
    qrcode
    pysearpc
    seaserv
    gunicorn
    markdown
    bleach
  ];

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:"
  '';

  passthru = {
    inherit python;
    pythonPath = python.pkgs.makePythonPath propagatedBuildInputs;
    tests = {
      inherit (nixosTests) seafile;
    };
  };

  meta = with lib; {
    description = "The web end of seafile server";
    homepage = "https://github.com/haiwen/seahub";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh schmittlauch ];
    platforms = platforms.linux;
  };
}
