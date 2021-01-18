{ lib, stdenv, bundlerEnv, ruby, makeWrapper, bundlerUpdateScript
, git }:

stdenv.mkDerivation rec {
  pname = "gollum";
  # nix-shell -p bundix icu zlib cmake pkg-config openssl
  version = (import ./gemset.nix).gollum.version;

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = let
    env = bundlerEnv {
      name = "${pname}-${version}-gems";
      inherit pname ruby;
      gemdir = ./.;
    };
  in ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/gollum $out/bin/gollum \
      --prefix PATH ":" ${lib.makeBinPath [ git ]}
    makeWrapper ${env}/bin/gollum-migrate-tags $out/bin/gollum-migrate-tags \
      --prefix PATH ":" ${lib.makeBinPath [ git ]}
  '';

  passthru.updateScript = bundlerUpdateScript "gollum";

  meta = with lib; {
    description = "A simple, Git-powered wiki with a sweet API and local frontend";
    homepage = "https://github.com/gollum/gollum";
    changelog = "https://github.com/gollum/gollum/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich primeos nicknovitski ];
    platforms = platforms.unix;
  };
}
