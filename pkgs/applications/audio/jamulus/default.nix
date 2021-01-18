{ mkDerivation, lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, qtscript, qmake, libjack2
}:

mkDerivation rec {
  pname = "jamulus";
  version = "3.6.1";
  src = fetchFromGitHub {
    owner = "corrados";
    repo = "jamulus";
    rev = "r${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "11rwgd2car7ziqa0vancb363m4ca94pj480jfxywd6d81139jl15";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ qtscript libjack2 ];

  qmakeFlags = [ "CONFIG+=noupcasename" ];

  meta = {
    description = "Enables musicians to perform real-time jam sessions over the internet";
    longDescription = "You also need to enable JACK and should enable several real-time optimizations. See project website for details";
    homepage = "https://github.com/corrados/jamulus/wiki";
    license = lib.licenses.gpl2; # linked in git repo, at least
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.seb314 ];
  };
}
