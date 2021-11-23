{ stdenv
, lib
, fetchFromGitHub
, bundlerEnv
, defaultGemConfig
, callPackage
, writeText
, procps
, ruby_2_7
, postgresql
, imlib2
, nodejs
, yarn
, yarn2nix-moretea
, v8
, cacert
}:

let
  pname = "zammad";
  version = "5.0.2";

  sourceDir = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  databaseConfig = writeText "database.yml" ''
    production:
      url: <%= ENV['DATABASE_URL'] %>
  '';

  secretsConfig = writeText "secrets.yml" ''
    production:
      secret_key_base: <%= ENV['SECRET_KEY_BASE'] %>
  '';

  rubyEnv = bundlerEnv {
    name = "${pname}-gems-${version}";
    inherit version;

    # Which ruby version to select:
    #   https://docs.zammad.org/en/latest/prerequisites/software.html#ruby-programming-language
    inherit ruby_2_7;

    gemdir = sourceDir;
    gemset = ./gemset.nix;
    groups = [
      "assets"
      "unicorn"   # server
      "nulldb"
      "test"
      "mysql"
      "puma"
      "development"
      "postgres"  # database
    ];
    gemConfig = defaultGemConfig // {
      pg = attrs: {
        buildFlags = [ "--with-pg-config=${postgresql}/bin/pg_config" ];
      };
      rszr = attrs: {
        buildInputs = [ imlib2 imlib2.dev ];
      };
      mini_racer = attrs: {
        buildFlags = [
          "--with-v8-dir=\"${v8}\""
        ];
        dontBuild = false;
        postPatch = ''
          substituteInPlace ext/mini_racer_extension/extconf.rb \
            --replace Libv8.configure_makefile '$CPPFLAGS += " -x c++"; Libv8.configure_makefile'
        '';
      };
    };
  };

  yarnEnv = yarn2nix-moretea.mkYarnPackage {
    pname = "${pname}-node-modules";
    inherit version;
    src = sourceDir;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
    packageJSON = sourceDir + "/package.json";
  };

in stdenv.mkDerivation {
  name = "${pname}-${version}";
  inherit pname version;

  src = sourceDir;

  patches = [
    ./0001-nulldb.patch
  ];

  buildInputs = [
    rubyEnv
    rubyEnv.wrappedRuby
    rubyEnv.bundler
    yarn
    nodejs
    procps
    cacert
  ];

  RAILS_ENV = "production";

  buildPhase = ''
    node_modules=${yarnEnv}/libexec/Zammad/node_modules
    ${yarn2nix-moretea.linkNodeModulesHook}

    rake DATABASE_URL="nulldb://user:pass@127.0.0.1/dbname" assets:precompile
  '';

  installPhase = ''
    mkdir -p $out/config
    cp -R ./* $out
    rm -R $out/tmp/*
    cp ${databaseConfig} $out/config/database.yml
    cp ${secretsConfig} $out/config/secrets.yml
    sed -i -e "s|info|debug|" $out/config/environments/production.rb
  '';

  passthru = {
    inherit rubyEnv yarnEnv;
    updateScript = [ "${callPackage ./update.nix {}}/bin/update.sh" pname (toString ./.) ];
  };

  meta = with lib; {
    description = "Zammad, a web-based, open source user support/ticketing solution.";
    homepage = "https://zammad.org";
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ n0emis ];
  };
}
