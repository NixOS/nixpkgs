{ clipnotify, makeWrapper, xsel, dmenu2, utillinux, gawk, stdenv, fetchFromGitHub, lib }:
let
  runtimePath = lib.makeBinPath [ clipnotify xsel dmenu2 utillinux gawk ];
in
stdenv.mkDerivation rec {
  name = "clipmenu-${version}";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner  = "cdown";
    repo   = "clipmenu";
    rev    = version;
    sha256 = "13hyarzazh6j33d808h3s5yk320wqzivc0ni9xm8kalvn4k3a0bq";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp clipdel clipmenu clipmenud $out/bin

    for bin in $out/bin/*; do
      wrapProgram "$bin" --prefix PATH : "${runtimePath}"
    done
  '';

  meta = with stdenv.lib; {
    description = "Clipboard management using dmenu";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.publicDomain;
  };
}
