args: with args;
stdenv.mkDerivation (rec {
  pname = "rxvt-unicode";
  version = "9.06";

  name = "${pname}-${version}";

 src = fetchurl {
    url = "http://dist.schmorp.de/rxvt-unicode/Attic/${name}.tar.bz2";
    sha256 = "8ef9359c01059efd330626c6cd7b082be9bf10587f2b9fe84caa43a84aa576d1";
  };

  buildInputs = [ libX11 libXt libXft ncurses /* required to build the terminfo file */ ];

  preConfigure=''
    configureFlags="--disable-perl";
    export TERMINFO=$out/share/terminfo # without this the terminfo won't be compiled by tic, see man tic
  '';

  meta = {
    description = "rxvt-unicode is a clone of the well known terminal emulator rxvt.";
    longDescription = "
      you should put this into your .bashrc
      export TERMINFO=~/.nix-profile/share/terminfo
    ";
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
  };
})
