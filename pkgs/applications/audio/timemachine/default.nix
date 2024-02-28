{ lib, stdenv, fetchFromGitHub, autoconf, automake, pkg-config, gtk2
, libjack2, libsndfile
}:

stdenv.mkDerivation rec {
  pname = "timemachine";
  version = "0.3.4";
  src = fetchFromGitHub {
    owner = "swh";
    repo = "timemachine";
    rev = "v${version}";
    sha256 = "16fgyw6jnscx9279dczv72092dddghwlp53rkfw469kcgvjhwx0z";
  };

  nativeBuildInputs = [ pkg-config autoconf automake ];
    buildInputs = [ gtk2 libjack2
      libsndfile
    ];

  preConfigure = "./autogen.sh";

  NIX_LDFLAGS = "-lm";

  meta = {
    description = "JACK audio recorder";
    homepage = "http://plugin.org.uk/timemachine/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
    mainProgram = "timemachine";
  };
}

