{ stdenv, lib, bundler, fetchgit, bundlerEnv, defaultGemConfig, libiconv, ruby
, tzdata, git
}:

let
  gitlab = fetchgit {
    url = "https://github.com/gitlabhq/gitlabhq.git";
    rev = "477743a154e85c411e8a533980abce460b5669fc";
    fetchSubmodules = false;
    sha256 = "0jl1w9d46v8hc27h9s380ha07m3fd2zpflj4q9vywwcf570ahj7x";
  };

  env = bundlerEnv {
    name = "gitlab";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    meta = with lib; {
      homepage = http://www.gitlab.com/;
      platforms = platforms.linux;
      maintainers = [ ];
      license = licenses.mit;
    };
  };

in

stdenv.mkDerivation rec {
  name = "gitlab-${version}";
  version = "7.4.2";
  buildInputs = [ ruby bundler tzdata git ];
  unpackPhase = ''
    runHook preUnpack
    cp -r ${gitlab}/* .
    chmod -R +w .
    cp ${./Gemfile} Gemfile
    cp ${./Gemfile.lock} Gemfile.lock
    runHook postUnpack
  '';
  patches = [
    ./remove-hardcoded-locations.patch
  ];
  postPatch = ''
    # For reasons I don't understand "bundle exec" ignores the
    # RAILS_ENV causing tests to be executed that fail because we're
    # not installing development and test gems above. Deleting the
    # tests works though.:
    rm lib/tasks/test.rake

    mv config/gitlab.yml.example config/gitlab.yml

    # required for some gems:
    cat > config/database.yml <<EOF
      production:
        adapter: postgresql
        database: gitlab
        host: <%= ENV["GITLAB_DATABASE_HOST"] || "127.0.0.1" %>
        password: <%= ENV["GITLAB_DATABASE_PASSWORD"] || "blerg" %>
        username: gitlab
        encoding: utf8
    EOF
  '';
  buildPhase = ''
    export GEM_HOME=${env}/${ruby.gemPath}
    bundle exec rake assets:precompile RAILS_ENV=production
  '';
  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/gitlab
  '';
  passthru = {
    inherit env;
    inherit ruby;
  };
}
