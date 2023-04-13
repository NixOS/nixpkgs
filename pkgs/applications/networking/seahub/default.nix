{ lib
, fetchFromGitHub
, python3
, makeWrapper
, nixosTests
}:
let
  # Seahub 8.x.x does not support django-webpack-loader >=1.x.x
  python = python3.override {
    packageOverrides = self: super: {
      django-webpack-loader = super.django-webpack-loader.overridePythonAttrs (old: rec {
        version = "0.7.0";
        src = old.src.override {
          inherit version;
          hash = "sha256-ejyIIBqlRIH5OZRlYVy+e5rs6AgUlqbQKHt8uOIy9Ec=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "seahub";
  version = "9.0.10";
  format = "other";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "5971bf25fe67d94ec4d9f53b785c15a098113620"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "sha256-7Exvm3EShb/1EqwA4wzWB9zCdv0P/ISmjKSoqtOMnqk=";
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
