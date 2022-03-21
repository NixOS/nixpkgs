{ lib, fetchFromGitHub, python3, makeWrapper }:
let
  # Seahub 8.x.x does not support django-webpack-loader >=1.x.x
  python = python3.override {
    packageOverrides = self: super: {
      django-webpack-loader = super.django-webpack-loader.overridePythonAttrs (old: rec {
        version = "0.7.0";
        src = old.src.override {
          inherit version;
          sha256 = "0izl6bibhz3v538ad5hl13lfr6kvprf62rcl77wq2i5538h8hg3s";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "seahub";
  version = "8.0.8";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "c51346155b2f31e038c3a2a12e69dcc6665502e2"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "0dagiifxllfk73xdzfw2g378jccpzplhdrmkwbaakbhgbvvkg92k";
  };

  dontBuild = true;
  doCheck = false; # disabled because it requires a ccnet environment

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python.pkgs; [
    django
    future
    django-statici18n
    django-webpack-loader
    django-simple-captcha
    django-picklefield
    django-formtools
    mysqlclient
    pillow
    python-dateutil
    django_compressor
    djangorestframework
    openpyxl
    requests
    requests_oauthlib
    pyjwt
    pycryptodome
    qrcode
    pysearpc
    seaserv
    gunicorn
  ];

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:"
  '';

  passthru = {
    inherit python;
    pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;
  };

  meta = with lib; {
    homepage = "https://github.com/haiwen/seahub";
    description = "The web end of seafile server";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
