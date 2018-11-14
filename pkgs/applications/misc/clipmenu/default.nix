{ clipnotify, makeWrapper, xsel, dmenu2, utillinux, gawk, stdenv, fetchFromGitHub, lib }:
let
  runtimePath = lib.makeBinPath [ clipnotify xsel dmenu2 utillinux gawk ];
in
stdenv.mkDerivation rec {
  name = "clipmenu-${version}";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner  = "cdown";
    repo   = "clipmenu";
    rev    = version;
    sha256 = "15if7bwqviyynbrcwrn04r418cfnxf2mkmq112696np24bggvljg";
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
