{ clipnotify, makeWrapper, xsel, dmenu, util-linux, gawk, stdenv, fetchFromGitHub, lib }:
let
  runtimePath = lib.makeBinPath [ clipnotify xsel dmenu util-linux gawk ];
in
stdenv.mkDerivation rec {
  pname = "clipmenu";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner  = "cdown";
    repo   = "clipmenu";
    rev    = version;
    sha256 = "sha256-nvctEwyho6kl4+NXi76jT2kG7nchmI2a7mgxlgjXA5A=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ xsel clipnotify ];

  installPhase = ''
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
