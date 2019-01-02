{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook
, libtool, pkgconfig, gtk2, libGLU, file
}:

let
  gtkglarea = stdenv.mkDerivation rec {
    name    = "gtkglarea-${version}";
    version = "2.1.0";
    src = fetchurl {
      url    = "mirror://gnome/sources/gtkglarea/2.1/${name}.tar.xz";
      sha256 = "1pl2vdj6l64j864ilhkq1bcggb3hrlxjwk5m029i7xfjfxc587lf";
    };
    nativeBuildInputs = [ pkgconfig ];
    buildInputs       = [ gtk2 libGLU ];
    hardeningDisable  = [ "format" ];
  };

in stdenv.mkDerivation rec {
  name    = "fsv-${version}";
  version = "0.9-1";

  src = fetchFromGitHub {
    owner  = "mcuelenaere"; 
    repo   = "fsv";
    rev    = name;
    sha256 = "0n09jd7yqj18mx6zqbg7kab4idg5llr15g6avafj74fpg1h7iimj";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig ];
  buildInputs       = [ file gtk2 libGLU gtkglarea ];

  meta = with stdenv.lib; {
    description     = "fsv is a file system visualizer in cyberspace";
    longDescription = ''
      fsv (pronounced eff-ess-vee) is a file system visualizer in cyberspace.
      It lays out files and directories in three dimensions, geometrically
      representing the file system hierarchy to allow visual overview
      and analysis. fsv can visualize a modest home directory, a workstation's
      hard drive, or any arbitrarily large collection of files, limited only
      by the host computer's memory and graphics hardware.
    '';
    homepage    = https://github.com/mcuelenaere/fsv;
    license     = licenses.lgpl2;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
