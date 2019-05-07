{ stdenv
, fetchFromGitHub
, cmake
, alsaLib
, libX11
}:

stdenv.mkDerivation rec {
  name = "osmid";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "llloret";
    repo = "osmid";
    rev = "v${version}";
    sha256 = "1lvdn05y5b0gfpf9y5zk84pw7phm7x0qbivixx8yy111na7p3rd5";
  };

  buildInputs = [ cmake alsaLib libX11 ];

  installPhase = ''
    mkdir -p $out/bin
    cp {m2o,o2m} $out/bin/
  '';

  meta = {
    homepage = https://github.com/llloret/osmid;
    description = "A lightweight, portable, easy to use tool to convert MIDI to OSC and OSC to MIDI";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ c0deaddict ];
    platforms = stdenv.lib.platforms.linux;
  };
}
