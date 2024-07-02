{ lib
, fetchFromGitHub
, fetchpatch
, python3
, makeWrapper
, nixosTests
, seafile-server-override ? null
}:
let
  python = python3.override (lib.optionalAttrs (!builtins.isNull seafile-server-override) {
    packageOverrides = final: prev: {
      seaserv = prev.toPythonModule (seafile-server-override.override {
        python3 = prev.python;
      });
    };
  });
in
python.pkgs.buildPythonApplication rec {
  pname = "seahub";
  version = "11.0.9";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "40b0ba08d6c298a744c6df0d53e057cf7f805881"; # using a fixed revision because upstream may re-tag releases :/
    hash = "sha256-m7xWOO5FW7p8D3e7alIqhBR83/XeDGRsN2d3npVE1CY=";
  };

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
    pyopenssl
    python-ldap
    qrcode
    pysearpc
    gunicorn
    markdown
    bleach

    seaserv
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
    seafile-server = python.pkgs.seaserv;
  };

  meta = with lib; {
    description = "Web end of seafile server";
    homepage = "https://github.com/haiwen/seahub";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh schmittlauch ];
    platforms = platforms.linux;
  };
}
