{ mkDerivation, stdenv, fetchFromGitHub, fetchpatch, pkg-config, qtscript, qmake, libjack2
}:

mkDerivation rec {
  pname = "jamulus";
  version = "3.5.5";
  src = fetchFromGitHub {
    owner = "corrados";
    repo = "jamulus";
    rev = "r${stdenv.lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "04h0nwlj71qbp7h4yn8djqchrf47jk8rab9zp9bh9pnkcyv60h27";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ qtscript libjack2 ];

  qmakeFlags = [ "CONFIG+=noupcasename" ];

  meta = {
    description = "Enables musicians to perform real-time jam sessions over the internet";
    longDescription = "You also need to enable JACK and should enable several real-time optimizations. See project website for details";
    homepage = "https://github.com/corrados/jamulus/wiki";
    license = stdenv.lib.licenses.gpl2; # linked in git repo, at least
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.seb314 ];
  };
}
