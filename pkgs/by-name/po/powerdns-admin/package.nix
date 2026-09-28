{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_4-fetcher,
  nixosTests,
  writeText,
  runCommand,
  python3,
}:

let
  pname = "powerdns-admin";
  version = "2026.08.1";
  src = fetchFromGitHub {
    owner = "PowerDNS-Admin";
    repo = "PowerDNS-Admin";
    tag = "v${version}";
    hash = "sha256-henbXspZfO8n0V0v63/7nOO5s01f5c7QMtcseeBFKVY=";
  };

  inherit (yarn-berry_4-fetcher) fetchYarnBerryDeps yarnBerryConfigHook;

  yarnLock = runCommand "yarn-v9.lock" { } ''
    sed -e 's/^  version: 8$/  version: 9/' ${src}/yarn.lock > $out
  '';

  python = python3;

  pythonDeps = with python.pkgs; [
    flask
    flask-assets
    flask-login
    flask-sqlalchemy
    flask-migrate
    flask-seasurf
    flask-mail
    flask-session
    flask-session-captcha
    flask-sslify
    mysqlclient
    psycopg2
    sqlalchemy
    certifi
    cffi
    cryptography
    bcrypt
    requests
    python-ldap
    pyotp
    qrcode
    dnspython
    gunicorn
    itsdangerous
    python3-saml
    pytz
    rcssmin
    rjsmin
    authlib
    bravado-core
    lima
    lxml
    pyasn1
    pytimeparse
    pyyaml
    jinja2
    setuptools
    webcolors
    werkzeug
    zxcvbn
  ];

  assets = stdenv.mkDerivation {
    pname = "${pname}-assets";
    inherit version src;

    offlineCache = fetchYarnBerryDeps {
      inherit yarnLock;
      hash = "sha256-VVew6/rjc0Uz6xM2komL9Sceym3vFrGnAqrdLtGxQVI=";
    };

    postPatch = ''
      cp ${yarnLock} yarn.lock
      # flask-assets needs a real node_modules tree
      printf 'nodeLinker: node-modules\n' >> .yarnrc.yml
    '';

    nativeBuildInputs = [
      yarnBerryConfigHook
    ]
    ++ pythonDeps;

    buildPhase = ''
      runHook preBuild

      if [ -d node_modules ] && [ ! -d powerdnsadmin/static/node_modules ]; then
        mv node_modules powerdnsadmin/static/node_modules
      fi

      SESSION_TYPE=filesystem \
      SQLALCHEMY_DATABASE_URI="sqlite:///:memory:" \
      FLASK_APP=./powerdnsadmin/__init__.py \
        flask assets build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/v2026.08.1/docker/common/Dockerfile.app
      mkdir $out
      cp -r powerdnsadmin/static/{generated,assets,img,custom} $out
      mkdir -p $out/node_modules/@fortawesome/fontawesome-free
      cp -r powerdnsadmin/static/node_modules/@fortawesome/fontawesome-free/webfonts \
        $out/node_modules/@fortawesome/fontawesome-free/

      runHook postInstall
    '';
  };

  assetsPy = writeText "assets.py" ''
    from flask_assets import Environment
    assets = Environment()
    assets.register('js_login', 'generated/login.js')
    assets.register('css_login', 'generated/login.css')
    assets.register('js_main', 'generated/main.js')
    assets.register('css_main', 'generated/main.css')
  '';
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ python.pkgs.wrapPython ];

  pythonPath = pythonDeps;

  gunicornScript = ''
    #!/bin/sh
    if [ ! -z $CONFIG ]; then
      exec python -m gunicorn.app.wsgiapp "powerdnsadmin:create_app(config='$CONFIG')" "$@"
    fi

    exec python -m gunicorn.app.wsgiapp "powerdnsadmin:create_app()" "$@"
  '';

  postPatch = ''
    rm -r powerdnsadmin/static powerdnsadmin/assets.py
  '';

  installPhase = ''
    runHook preInstall

    # Nasty hack: call wrapPythonPrograms to set program_PYTHONPATH (see tribler)
    wrapPythonPrograms

    mkdir -p $out/share $out/bin
    cp -r migrations powerdnsadmin $out/share/

    ln -s ${assets} $out/share/powerdnsadmin/static
    ln -s ${assetsPy} $out/share/powerdnsadmin/assets.py

    echo "$gunicornScript" > $out/bin/powerdns-admin
    chmod +x $out/bin/powerdns-admin
    wrapProgram $out/bin/powerdns-admin \
      --set PATH ${python.pkgs.python}/bin \
      --set PYTHONPATH $out/share:$program_PYTHONPATH

    runHook postInstall
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    # PYTHONPATH of all dependencies used by the package
    pythonPath = python3.pkgs.makePythonPath pythonDeps;
    tests = nixosTests.powerdns-admin;
  };

  meta = {
    description = "PowerDNS web interface with advanced features";
    mainProgram = "powerdns-admin";
    homepage = "https://github.com/PowerDNS-Admin/PowerDNS-Admin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Flakebi
      zhaofengli
    ];
  };
}
