{ lib, stdenv, fetchFromGitHub, mkYarnPackage, nixosTests, writeText, python3 }:

let
  version = "0.2.3";
  src = fetchFromGitHub {
    owner = "ngoduykhanh";
    repo = "PowerDNS-Admin";
    rev = "v${version}";
    sha256 = "16faz57d77mxkflkvwyi8gb9wvnq2vhw79b84v1fmqvxri1yaphw";
  };

  python = python3.override {
    packageOverrides = self: super: {
      dnspython = super.dnspython.overridePythonAttrs (oldAttrs: rec {
        version = "1.16.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01";
        };
      });
    };
  };

  pythonDeps = with python.pkgs; [
    flask flask_assets flask_login flask_sqlalchemy flask_migrate flask-seasurf flask_mail flask-sslify
    mysqlclient psycopg2 sqlalchemy
    cffi configobj cryptography bcrypt requests ldap pyotp qrcode dnspython
    gunicorn python3-saml pyopenssl pytz cssmin jsmin authlib bravado-core
    lima pytimeparse pyyaml
  ];

  assets = mkYarnPackage {
    inherit src version;
    packageJSON = ./package.json;
    yarnNix = ./yarndeps.nix;

    nativeBuildInputs = pythonDeps;
    patchPhase = ''
      sed -i -r -e "s|'cssmin',\s?'cssrewrite'|'cssmin'|g" powerdnsadmin/assets.py
    '';
    buildPhase = ''
      # The build process expects the directory to be writable
      # with node_modules at a specific path
      # https://github.com/ngoduykhanh/PowerDNS-Admin/blob/master/.yarnrc

      approot=deps/powerdns-admin-assets

      ln -s $node_modules $approot/powerdnsadmin/static/node_modules
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
in stdenv.mkDerivation rec {
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
    sed -i "s/id:/'id':/" migrations/versions/787bdba9e147_init_db.py
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
    homepage = "https://github.com/ngoduykhanh/PowerDNS-Admin";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
