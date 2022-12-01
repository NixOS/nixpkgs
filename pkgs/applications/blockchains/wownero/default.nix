{ lib, stdenv, fetchFromGitea, cmake, boost, miniupnpc, openssl, unbound
, readline, libsodium, rapidjson
}:

with lib;
stdenv.mkDerivation rec {
  pname = "wownero";
  version = "0.8.0.1";
  randomwowVersion = "1.1.7";

  src = fetchFromGitea {
    domain = "git.wownero.com";
    owner = "wownero";
    repo = "wownero";
    rev = "v${version}";
    sha256 = "sha256-+cUdousEiZMNwqhTvjoqw/k21x3dg7Lhb/5KyNUGrjQ=";
    fetchSubmodules = false;
  };

  randomwow = fetchFromGitea {
    domain = "git.wownero.com";
    owner = "wownero";
    repo = "RandomWOW";
    rev = randomwowVersion;
    sha256 = "sha256-JzyRlHwM8rmJ5OaKHz+6vHGfpSz+X4zkFAKn4Jmo+EE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost miniupnpc openssl unbound rapidjson readline libsodium
  ];

  postUnpack = ''
    rm -r $sourceRoot/external/RandomWOW
    ln -s ${randomwow} $sourceRoot/external/RandomWOW
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
    maintainers = with maintainers; [ ];
  };
}
