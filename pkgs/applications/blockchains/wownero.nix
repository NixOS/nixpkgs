{ stdenv, fetchgit, cmake, boost, miniupnpc_2, openssl, unbound
, readline, libsodium, rapidjson, fetchurl
}:

with stdenv.lib;

let
  randomwowVersion = "1.1.7";
  randomwow = fetchurl {
    url = "https://github.com/wownero/RandomWOW/archive/${randomwowVersion}.tar.gz";
    sha256 = "1xp76zf01hnhnk6rjvqjav9n9pnvxzxlzqa5rc574d1c2qczfy3q";
  };
in

stdenv.mkDerivation rec {
  pname = "wownero";
  version = "0.8.0.1";

  src = fetchgit {
    url = "https://git.wownero.com/wownero/wownero.git";
    rev = "v${version}";
    sha256 = "15443xv6q1nw4627ajk6k4ghhahvh82lb4gyb8nvq753p2v838g3";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost miniupnpc_2 openssl unbound rapidjson readline libsodium
  ];

  postUnpack = ''
    rm -r $sourceRoot/external/RandomWOW
    unpackFile ${randomwow}
    mv RandomWOW-${randomwowVersion} $sourceRoot/external/RandomWOW
  '';

  cmakeFlags = [
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DMANUAL_SUBMODULES=ON"
  ];

  meta = {
    description = ''
      A privacy-centric memecoin that was fairly launched on April 1, 2018 with
      no pre-mine, stealth-mine or ICO
    '';
    longDescription = ''
      Wownero has a maximum supply of around 184 million WOW with a slow and
      steady emission over 50 years. It is a fork of Monero, but with its own
      genesis block, so there is no degradation of privacy due to ring
      signatures using different participants for the same tx outputs on
      opposing forks.
    '';
    homepage    = "https://wownero.org/";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ fuwa ];
  };
}
