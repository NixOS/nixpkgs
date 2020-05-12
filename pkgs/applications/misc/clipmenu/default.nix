{ clipnotify, makeWrapper, xsel, dmenu, utillinux, gawk, stdenv, fetchFromGitHub, lib }:
let
  runtimePath = lib.makeBinPath [ clipnotify xsel dmenu utillinux gawk ];
in
stdenv.mkDerivation rec {
  pname = "clipmenu";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner  = "cdown";
    repo   = "clipmenu";
    rev    = version;
    sha256 = "0053j4i14lz5m2bzc5sch5id5ilr1bl196mp8fp0q8x74w3vavs9";
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
