{ clipnotify, makeWrapper, xsel, dmenu2, utillinux, gawk, stdenv, fetchFromGitHub, lib }:
let
  runtimePath = lib.makeBinPath [ clipnotify xsel dmenu2 utillinux gawk ];
in
stdenv.mkDerivation rec {
  name = "clipmenu-${version}";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner  = "cdown";
    repo   = "clipmenu";
    rev    = version;
    sha256 = "1qbpca0wny6i222vbikfl2znn3fynhbl4100qs8v4wn27ra5p0mi";
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
