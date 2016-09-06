{ stdenv, lib, fetchFromGitHub, bundlerEnv, ruby
, withPostgresql ? true, postgresql
, withSqlite ? false, sqlite
}:

let
  _name = "ledger-web";
  cmd = "ledger_web";

  env = bundlerEnv {
    name = "${_name}-env";
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

  buildInputs = [ env ruby ]
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
    mkdir -p $out/bin

    cp --no-preserve=mode -r lib $out

    ln -s ${env}/bin/${cmd} $out/bin/${cmd}
  '';
}
