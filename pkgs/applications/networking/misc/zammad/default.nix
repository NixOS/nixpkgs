{ stdenv
, lib
, fetchFromGitHub
, applyPatches
, bundlerEnv
, defaultGemConfig
, callPackage
, writeText
, procps
, ruby_3_0
, postgresql
, imlib2
, jq
, moreutils
, nodejs
, yarn
, yarn2nix-moretea
, v8
, cacert
}:

let
  pname = "zammad";
  version = "5.3.1";

  src = applyPatches {

    src = fetchFromGitHub (lib.importJSON ./source.json);

    patches = [ ./0001-nulldb.patch ];

    postPatch = ''
      sed -i -e "s|ruby '3.0.[0-9]\+'|ruby '${ruby_3_0.version}'|" Gemfile
      sed -i -e "s|ruby 3.0.[0-9]\+p[0-9]\+|ruby ${ruby_3_0.version}|" Gemfile.lock
      sed -i -e "s|3.0.[0-9]\+|${ruby_3_0.version}|" .ruby-version
      ${jq}/bin/jq '. += {name: "Zammad", version: "${version}"}' package.json | ${moreutils}/bin/sponge package.json
    '';
  };

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
    ruby = ruby_3_0;

    gemdir = src;
    gemset = ./gemset.nix;
    groups = [
      "assets"
      "unicorn" # server
      "nulldb"
      "test"
      "mysql"
      "puma"
      "development"
      "postgres" # database
    ];
    gemConfig = defaultGemConfig // {
      pg = attrs: {
        buildFlags = [ "--with-pg-config=${postgresql}/bin/pg_config" ];
      };
      rszr = attrs: {
        buildInputs = [ imlib2 imlib2.dev ];
        buildFlags = [ "--without-imlib2-config" ];
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
    inherit version src;
    yarnLock = src + /yarn.lock;
    packageJSON = ./package.json;
    #FIXME: packageResolutions should be remove when https://github.com/NixOS/nixpkgs/pull/214952/ is merged
    packageResolutions = (lib.importJSON ./package.json).resolutions;
  };

in
stdenv.mkDerivation {
  inherit pname version src;

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
    cp -R . $out
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
    maintainers = with maintainers; [ n0emis garbas taeer ];
  };
}
