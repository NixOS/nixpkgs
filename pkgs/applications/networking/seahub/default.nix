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
          sha256 = "0izl6bibhz3v538ad5hl13lfr6kvprf62rcl77wq2i5538h8hg3s";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "seahub";
  version = "9.0.6";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "876b7ba9b680fc668e89706aff535593772ae921"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "sha256-GHvJlm5DVt3IVJnqJu8YobNNqbjdPd08s4DCdQQRQds=";
  };

  format = "other";

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
