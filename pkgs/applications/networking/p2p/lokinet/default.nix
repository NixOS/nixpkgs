{ stdenv
, lib
, fetchFromGitHub
, cmake
, libevent
, libsodium
, libuv
, nlohmann_json
, pkg-config
, spdlog
<<<<<<< HEAD
, fmt_9
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sqlite
, systemd
, unbound
, zeromq
}:
<<<<<<< HEAD
let
  # Upstream has received reports of incompatibilities with fmt, and other
  # dependencies, see: https://github.com/oxen-io/lokinet/issues/2200.
  spdlog' = spdlog.override {
    fmt = fmt_9;
  };

in stdenv.mkDerivation rec {
=======

stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "lokinet";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "oxen-io";
    repo = "lokinet";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-aVFLDGTbRUOw2XWDpl+ojwHBG7c0miGeoKMLwMpqVtg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libevent
    libuv
    libsodium
    nlohmann_json
<<<<<<< HEAD
    spdlog'
=======
    spdlog
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sqlite
    systemd
    unbound
    zeromq
  ];

  cmakeFlags = [
    "-DGIT_VERSION=v${version}"
    "-DWITH_BOOTSTRAP=OFF" # we provide bootstrap files manually
    "-DWITH_SETCAP=OFF"
  ];

  meta = with lib; {
    description = "Anonymous, decentralized and IP based overlay network for the internet";
    homepage = "https://lokinet.org/";
    changelog = "https://github.com/oxen-io/lokinet/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wyndon ];
  };
}
