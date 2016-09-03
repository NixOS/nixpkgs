{ stdenv, lib, fetchFromGitHub, makeWrapper, bundlerEnv, ruby
, withPostgresql ? true, postgresql
, withSqlite ? false, sqlite
}:

let
  _name = "ledger-web";
  cmd = "ledger_web";

  env = bundlerEnv {
    name = _name;
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    meta = with lib; {
      homepage = https://github.com/peterkeen/ledger-web;
      platforms = platforms.linux;
      maintainers = [ peterhoeg ];
      license = licenses.mit;
    };
  };

in stdenv.mkDerivation rec {
  name = "${_name}-${version}";
  version = "1.5.2";

  buildInputs = [ env ruby makeWrapper ]
    ++ lib.optional withPostgresql postgresql
    ++ lib.optional withSqlite sqlite;

  src = fetchFromGitHub {
    owner = "peterkeen";
    repo = _name;
    rev = "v${version}";
    sha256 = "0an4d46h3pp7a8s96jl0dnw1imwdgnb2j474b9wrbidwc6cmfrm7";
  };

  dontStrip = true;

  installPhase = ''
    mkdir -p $out

    cp --no-preserve=mode -r bin lib $out

    chmod 0755 $out/bin/${cmd}

    wrapProgram $out/bin/${cmd} \
      --set BUNDLE_BIN ${env.bundler}/bin/bundle \
      --set GEM_PATH   ${env}/${env.ruby.gemPath}
  '';
}
