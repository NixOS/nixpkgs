{ stdenv
, lib
<<<<<<< HEAD
, nixosTests
, fetchFromGitHub
, fetchYarnDeps
=======
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, applyPatches
, bundlerEnv
, defaultGemConfig
, callPackage
, writeText
, procps
<<<<<<< HEAD
, ruby
=======
, ruby_2_7
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "5.4.1";
=======
  version = "5.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = applyPatches {

    src = fetchFromGitHub (lib.importJSON ./source.json);

<<<<<<< HEAD
    patches = [
      ./0001-nulldb.patch
      ./fix-sendmail-location.diff
    ];

    postPatch = ''
      sed -i -e "s|ruby '3.1.[0-9]\+'|ruby '${ruby.version}'|" Gemfile
      sed -i -e "s|ruby 3.1.[0-9]\+p[0-9]\+|ruby ${ruby.version}|" Gemfile.lock
      sed -i -e "s|3.1.[0-9]\+|${ruby.version}|" .ruby-version
=======
    patches = [ ./0001-nulldb.patch ];

    postPatch = ''
      sed -i -e "s|ruby '2.7.4'|ruby '${ruby_2_7.version}'|" Gemfile
      sed -i -e "s|ruby 2.7.4p191|ruby ${ruby_2_7.version}|" Gemfile.lock
      sed -i -e "s|2.7.4|${ruby_2_7.version}|" .ruby-version
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    inherit ruby;
=======
    inherit ruby_2_7;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-HI4RR4/ll/zNBNtDCb8OvEsG/BMVYacM0CcYqbkNHEY=";
    };

    yarnPreBuild = ''
      mkdir -p deps/Zammad
      cp -r ${src}/.eslint-plugin-zammad deps/Zammad/.eslint-plugin-zammad
      chmod -R +w deps/Zammad/.eslint-plugin-zammad
    '';
=======
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
    packageJSON = ./package.json;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    tests = { inherit (nixosTests) zammad; };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Zammad, a web-based, open source user support/ticketing solution.";
    homepage = "https://zammad.org";
    license = licenses.agpl3Plus;
<<<<<<< HEAD
    platforms = [ "x86_64-linux" "aarch64-linux" ];
=======
    platforms = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ n0emis garbas taeer ];
  };
}
