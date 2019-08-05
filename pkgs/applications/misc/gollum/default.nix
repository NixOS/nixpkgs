{ stdenv, bundlerEnv, ruby, makeWrapper, bundlerUpdateScript
, git }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "gollum";
  # nix-shell -p bundix icu zlib
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

  passthru.updateScript = bundlerUpdateScript "gollum";

  meta = with stdenv.lib; {
    description = "A simple, Git-powered wiki";
    homepage = https://github.com/gollum/gollum;
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich primeos nicknovitski ];
    platforms = platforms.unix;
  };
}
