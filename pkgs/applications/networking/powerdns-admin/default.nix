{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
  nixosTests,
  writeText,
  python3,
}:

let
  version = "0.4.2";
  src = fetchFromGitHub {
    owner = "PowerDNS-Admin";
    repo = "PowerDNS-Admin";
    rev = "v${version}";
    hash = "sha256-q9mt8wjSNFb452Xsg+qhNOWa03KJkYVGAeCWVSzZCyk=";
  };

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
    configobj
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
    passlib
    pyasn1
    pytimeparse
    pyyaml
    jinja2
    itsdangerous
    webcolors
    werkzeug
    zipp
    zxcvbn
  ];

  all_patches = [
    ./0001-Fix-flask-2.3-issue.patch
  ];

  assets = mkYarnPackage {
    inherit src version;
    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-rXIts+dgOuZQGyiSke1NIG7b4lFlR/Gfu3J6T3wP3aY=";
    };

    # Copied from package.json, see also
    # https://github.com/NixOS/nixpkgs/pull/214952
    packageResolutions = {
      "@fortawesome/fontawesome-free" = "6.3.0";
    };

    nativeBuildInputs = pythonDeps;
    patches = all_patches ++ [
      ./0002-Remove-cssrewrite-filter.patch
    ];
    buildPhase = ''
      # The build process expects the directory to be writable
      # with node_modules at a specific path
      # https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/.yarnrc

      approot=deps/powerdns-admin-assets

      ln -s $node_modules $approot/powerdnsadmin/static/node_modules
      SESSION_TYPE=filesystem FLASK_APP=$approot/powerdnsadmin/__init__.py flask assets build
    '';
    installPhase = ''
      # https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/54b257768f600c5548a1c7e50eac49c40df49f92/docker/Dockerfile#L43
      mkdir $out
      cp -r $approot/powerdnsadmin/static/{generated,assets,img} $out
      find $node_modules -name webfonts -exec cp -r {} $out \;
      find $node_modules -name fonts -exec cp -r {} $out \;
      find $node_modules/icheck/skins/square -name '*.png' -exec cp {} $out/generated \;
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
in
stdenv.mkDerivation {
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

  patches = all_patches ++ [
    ./0003-Fix-flask-migrate-4.0-compatibility.patch
    ./0004-Fix-flask-session-and-powerdns-admin-compatibility.patch
    ./0005-Use-app-context-to-create-routes.patch
    ./0006-Register-modules-before-starting.patch
  ];

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

  passthru = {
    # PYTHONPATH of all dependencies used by the package
    pythonPath = python3.pkgs.makePythonPath pythonDeps;
    tests = nixosTests.powerdns-admin;
  };

  meta = with lib; {
    description = "A PowerDNS web interface with advanced features";
    mainProgram = "powerdns-admin";
    homepage = "https://github.com/PowerDNS-Admin/PowerDNS-Admin";
    license = licenses.mit;
    maintainers = with maintainers; [
      Flakebi
      zhaofengli
    ];
  };
}
