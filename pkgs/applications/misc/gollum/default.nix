{ stdenv, bundlerEnv, ruby, makeWrapper
, git }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "gollum";
  version = (import ./gemset.nix).gollum.version;

  nativeBuildInputs = [ makeWrapper ];

  env = bundlerEnv {
    name = "${name}-gems";
    inherit pname ruby;
    gemdir = ./.;
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/gollum $out/bin/gollum \
      --prefix PATH ":" ${stdenv.lib.makeBinPath [ git ]}
  '';

  meta = with stdenv.lib; {
    description = "A simple, Git-powered wiki";
    homepage = "https://github.com/gollum/gollum";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich primeos ];
    platforms = platforms.unix;
  };
}
