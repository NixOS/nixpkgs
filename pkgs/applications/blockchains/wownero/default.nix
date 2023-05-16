<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, libsodium
, openssl
, rapidjson
, readline
, unbound
, zeromq
, darwin
}:

let
  # submodules
  miniupnp = fetchFromGitHub {
    owner = "miniupnp";
    repo = "miniupnp";
    rev = "miniupnpc_2_2_1";
    hash = "sha256-opd0hcZV+pjC3Mae3Yf6AR5fj6xVwGm9LuU5zEPxBKc=";
  };
  supercop = fetchFromGitHub {
    owner = "monero-project";
    repo = "supercop";
    rev = "633500ad8c8759995049ccd022107d1fa8a1bbc9";
    hash = "sha256-26UmESotSWnQ21VbAYEappLpkEMyl0jiuCaezRYd/sE=";
  };
  randomwow = fetchFromGitHub {
    owner = "wownero-project";
    repo = "RandomWOW";
    rev = "607bad48f3687c2490d90f8c55efa2dcd7cbc195";
    hash = "sha256-CJv96TbPv1k/C7MQWEntE6khIRX1iIEiF9wEdsQGiFQ=";
  };
in
stdenv.mkDerivation rec {
  pname = "wownero";
  version = "0.11.0.1";

  src = fetchFromGitHub {
    owner = "wownero-project";
    repo = "wownero";
    rev = "v${version}";
    fetchSubmodules = false;
    hash = "sha256-zmGsSbPpVwL0AhCQkdMKORruM5kYrrLe/BYfMphph8c=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    libsodium
    openssl
    rapidjson
    readline
    unbound
    zeromq
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
  ];

  postUnpack = ''
    rm -r $sourceRoot/external/miniupnp
    ln -s ${miniupnp} $sourceRoot/external/miniupnp

    rm -r $sourceRoot/external/randomwow
    ln -s ${randomwow} $sourceRoot/external/randomwow

    rm -r $sourceRoot/external/supercop
    ln -s ${supercop} $sourceRoot/external/supercop
=======
{ lib, stdenv, fetchFromGitea, cmake, boost, miniupnpc, openssl, unbound
, readline, libsodium, rapidjson
}:

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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  cmakeFlags = [
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DMANUAL_SUBMODULES=ON"
  ];

  meta = with lib; {
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
<<<<<<< HEAD
    homepage = "https://wownero.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
=======
    homepage    = "https://wownero.org/";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
