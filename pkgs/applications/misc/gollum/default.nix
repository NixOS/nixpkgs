{ stdenv, lib, bundlerEnv, ruby
, icu, zlib }:

bundlerEnv rec {
  name = "gollum-${version}";
  version = (import gemset).gollum.version;

  inherit ruby;
  gemdir = ./.;
  gemset = ./gemset.nix;

  # FIXME: Add Git as runtime dependency.

  meta = with lib; {
    description = "A simple, Git-powered wiki";
    homepage = "https://github.com/gollum/gollum";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich primeos ];
    platforms = platforms.unix;
  };
}
