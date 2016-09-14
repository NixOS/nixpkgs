{ stdenv, lib, bundler, fetchFromGitHub, bundlerEnv, ruby, curl, postgresql }:
let
  env = bundlerEnv {
    name = "huginn";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    meta = with lib; {
      homepage = http://www.github.com/cantino/huginn;
      platforms = platforms.linux;
      maintainers = [ mog ];
      license = licenses.mit;
    };

  };
in
stdenv.mkDerivation rec {
  name = "huginn-${version}";
  version = "2016-09-14";
  src = fetchFromGitHub {
    owner = "cantino";
    repo = "huginn";
    rev = "e44b524ab9aeecdcb10adb86eafb945ac8b91a94";
    sha256 = "1xbj4akdy9cr2h4imzm03lnmnz99angknasyip5farx81jbilcw7";
  };

  patches = [
    ./logfile.patch
    ./tmpfile.patch
  ];


  buildInputs = [env ruby bundler curl postgresql ];

  installPhase = ''
    export LD_LIBRARY_PATH=${curl.out}/lib:${postgresql}/lib
    RAILS_ENV=production APP_SECRET_TOKEN=REPLACE_ME_NOW! DATABASE_ADAPTER=nulldb HUGINN_STATE_PATH=tmp/ SKIP_STORAGE_VALIDATION=true bundle exec rake assets:precompile
    cp -r public/assets $out/share/huginn/public/
  '';

  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;

  buildPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/huginn
    cp ${gemfile} $out/share/huginn/Gemfile
    cp ${lockfile} $out/share/huginn/Gemfile.lock
#I dont know why these need to exist but what can i say
    mkdir -p $out/share/huginn/tmp/
    mkdir -p $out/share/huginn/tmp/cache
    mkdir -p $out/share/huginn/tmp/pids
    mkdir -p $out/share/huginn/tmp/sessions
    mkdir -p $out/share/huginn/tmp/sockets
  '';

  passthru = {
    inherit env;
    inherit ruby;
  };

}
