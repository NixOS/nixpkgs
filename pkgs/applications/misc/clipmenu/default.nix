{ clipnotify, makeWrapper, xsel, dmenu, utillinux, gawk, stdenv, fetchFromGitHub, fetchpatch, lib }:
let
  runtimePath = lib.makeBinPath [ clipnotify xsel dmenu utillinux gawk ];
in
stdenv.mkDerivation rec {
  pname = "clipmenu";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner  = "cdown";
    repo   = "clipmenu";
    rev    = version;
    sha256 = "0ddj5xcwrdb2qvrndvhv8j6swcqc8dvv5i00pqk35rfk5mrl4hwv";
  };
  
  patches = [
    (fetchpatch {
      url = "https://github.com/cdown/clipmenu/commit/443b58583ef216e2405e4a38d401f7c36386d21e.patch";
      sha256 = "12m4rpw7jbr31c919llbsmn8dcf7yh9aijln4iym6h2lylzqzzdz";
    })
  ];
  
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
