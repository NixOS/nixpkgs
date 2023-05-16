<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, fetchYarnDeps, mkYarnPackage, nixosTests, writeText, python3 }:

let
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "PowerDNS-Admin";
    repo = "PowerDNS-Admin";
    rev = "v${version}";
    hash = "sha256-AwqEcAPD1SF1Ma3wtH03mXlTywM0Q19hciCmTtlr3gk=";
=======
{ lib, stdenv, fetchFromGitHub, mkYarnPackage, nixosTests, writeText, python3 }:

let
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "ngoduykhanh";
    repo = "PowerDNS-Admin";
    rev = "v${version}";
    hash = "sha256-e11u0jdJr+2TDXvBAPlDfnuuDwSfBq+JtvnDUTNKp/c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  python = python3;

  pythonDeps = with python.pkgs; [
<<<<<<< HEAD
    flask flask-assets flask-login flask-sqlalchemy flask-migrate flask-seasurf flask-mail flask-session flask-session-captcha flask-sslify
    mysqlclient psycopg2 sqlalchemy
    certifi cffi configobj cryptography bcrypt requests python-ldap pyotp qrcode dnspython
    gunicorn itsdangerous python3-saml pytz rcssmin rjsmin authlib bravado-core
    lima lxml passlib pyasn1 pytimeparse pyyaml jinja2 itsdangerous webcolors werkzeug zipp zxcvbn
=======
    flask flask_assets flask-login flask-sqlalchemy flask_migrate flask-seasurf flask_mail flask-session flask-sslify
    mysqlclient psycopg2 sqlalchemy
    cffi configobj cryptography bcrypt requests python-ldap pyotp qrcode dnspython
    gunicorn python3-saml pytz cssmin rjsmin authlib bravado-core
    lima pytimeparse pyyaml jinja2 itsdangerous werkzeug
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  assets = mkYarnPackage {
    inherit src version;
    packageJSON = ./package.json;
<<<<<<< HEAD

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-3ebT19LrbYuypdJaoB3tClVVP0Fi8tHx3Xi6ge/DpA4=";
    };

    # Copied from package.json, see also
    # https://github.com/NixOS/nixpkgs/pull/214952
    packageResolutions = {
      "@fortawesome/fontawesome-free" = "6.3.0";
    };

    nativeBuildInputs = pythonDeps;
    patchPhase = ''
      sed -i -r -e "s|'rcssmin',\s?'cssrewrite'|'rcssmin'|g" powerdnsadmin/assets.py
=======
    yarnNix = ./yarndeps.nix;

    nativeBuildInputs = pythonDeps;
    patchPhase = ''
      sed -i -r -e "s|'cssmin',\s?'cssrewrite'|'cssmin'|g" powerdnsadmin/assets.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';
    buildPhase = ''
      # The build process expects the directory to be writable
      # with node_modules at a specific path
<<<<<<< HEAD
      # https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/.yarnrc
=======
      # https://github.com/ngoduykhanh/PowerDNS-Admin/blob/master/.yarnrc
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      approot=deps/powerdns-admin-assets

      ln -s $node_modules $approot/powerdnsadmin/static/node_modules
<<<<<<< HEAD
      SESSION_TYPE=filesystem FLASK_APP=$approot/powerdnsadmin/__init__.py flask assets build
    '';
    installPhase = ''
      # https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/54b257768f600c5548a1c7e50eac49c40df49f92/docker/Dockerfile#L43
      mkdir $out
      cp -r $approot/powerdnsadmin/static/{generated,assets,img} $out
      find $node_modules -name webfonts -exec cp -r {} $out \;
      find $node_modules -name fonts -exec cp -r {} $out \;
      find $node_modules/icheck/skins/square -name '*.png' -exec cp {} $out/generated \;
=======
      FLASK_APP=$approot/powerdnsadmin/__init__.py flask assets build
    '';
    installPhase = ''
      # https://github.com/ngoduykhanh/PowerDNS-Admin/blob/54b257768f600c5548a1c7e50eac49c40df49f92/docker/Dockerfile#L43
      mkdir $out
      cp -r $approot/powerdnsadmin/static/{generated,assets,img} $out
      find $node_modules/icheck/skins/square -name '*.png' -exec cp {} $out/generated \;

      mkdir $out/fonts
      cp $node_modules/ionicons/dist/fonts/* $out/fonts
      cp $node_modules/bootstrap/dist/fonts/* $out/fonts
      cp $node_modules/font-awesome/fonts/* $out/fonts
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';
    distPhase = "true";
  };

  assetsPy = writeText "assets.py" ''
    from flask_assets import Environment
    assets = Environment()
    assets.register('js_login', 'generated/login.js')
    assets.register('js_validation', 'generated/validation.js')
    assets.register('css_login', 'generated/login.css')
    assets.register('js_main', 'generated/main.js')
    assets.register('css_main', 'generated/main.css')
  '';
<<<<<<< HEAD
in stdenv.mkDerivation {
=======
in stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "powerdns-admin";

  inherit src version;

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
<<<<<<< HEAD
    # flask-migrate 4.0 compatibility: https://github.com/PowerDNS-Admin/PowerDNS-Admin/issues/1376
    substituteInPlace migrations/env.py --replace "render_as_batch=config.get_main_option('sqlalchemy.url').startswith('sqlite:')," ""
    # flask-session and powerdns-admin both try to add sqlalchemy to flask.
    # Reuse the database for flask-session
    substituteInPlace powerdnsadmin/__init__.py --replace "sess = Session(app)" "app.config['SESSION_SQLALCHEMY'] = models.base.db; sess = Session(app)"
    # Routes creates session database tables, so it needs a context
    substituteInPlace powerdnsadmin/__init__.py --replace "routes.init_app(app)" "with app.app_context(): routes.init_app(app)"
=======
    sed -i "s/id:/'id':/" migrations/versions/787bdba9e147_init_db.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  passthru = {
    # PYTHONPATH of all dependencies used by the package
    pythonPath = python3.pkgs.makePythonPath pythonDeps;
    tests = nixosTests.powerdns-admin;
  };

  meta = with lib; {
    description = "A PowerDNS web interface with advanced features";
<<<<<<< HEAD
    homepage = "https://github.com/PowerDNS-Admin/PowerDNS-Admin";
=======
    homepage = "https://github.com/ngoduykhanh/PowerDNS-Admin";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi zhaofengli ];
  };
}
