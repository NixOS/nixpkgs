{ stdenv, ruby, buildGoPackage, bundlerEnv, rubocop, rake, fetchFromGitLab, go }:

let
  rubyEnv = bundlerEnv rec {
    name = "gitlab-shell-env";
    inherit ruby;
    gemdir = ./rubyEnv;
    groups = [
      "default" "test"
    ];
  };

  version = "10.0.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "0n1llkb0jrqxm10l9wqmqxjycydqphgz0chbbf395d8pywyz826x";
  };

  goBits = buildGoPackage rec {
    inherit version src;
    name = "gitlab-shell-go";

    #patches = [ ./remove-hardcoded-locations.patch ];
    goDeps = ./deps.nix;
    goPackagePath= "gitlab.com/gitlab-org/gitlab-shell";

    meta = with stdenv.lib; {
      description = "SSH access and repository management app for GitLab";
      homepage = http://www.gitlab.com/;
      platforms = platforms.linux;
      maintainers = with maintainers; [ fpletz globin ];
      license = licenses.mit;
    };
  };

in

stdenv.mkDerivation rec {
  inherit version src;
  pname = "gitlab-shell";

  modSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  #buildInputs = [ rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler go rubocop ];
  nativeBuildInputs = [
    rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler
    goBits
  ];

  patches = [ ./remove-hardcoded-locations.patch ];

  preBuild = ''
    export HOME=$(pwd)
    cd go
  '';

  installPhase = ''
    export GOCACHE="$TMPDIR/go-cache"

    ruby bin/compile
    mkdir -p $out/
    cp -R . $out/

    # Nothing to install ATM for non-development but keeping the
    # install command anyway in case that changes in the future:
    export HOME=$(pwd)
    #bundle install -j4 --verbose --local --deployment --without development test
  '';

  # gitlab-shell will try to read its config relative to the source
  # code by default which doesn't work in nixos because it's a
  # read-only filesystem
  postPatch = ''
    substituteInPlace lib/gitlab_config.rb --replace \
       "File.join(ROOT_PATH, 'config.yml')" \
       "'/run/gitlab/shell-config.yml'"

    substituteInPlace support/go-format --replace \
       "/usr/bin/env ruby" \
       "${rubyEnv.wrappedRuby}/bin/ruby"
  '';

  buildPhase = "echo Hello";

  # Must skip test_ruby as it requires that /run/gitlab/shell-config.yml exists.
  installCheckPhase = '' '';
  checkPhase = ''
    make test_golang
  '';

  meta = with stdenv.lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = http://www.gitlab.com/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.mit;
  };
}
