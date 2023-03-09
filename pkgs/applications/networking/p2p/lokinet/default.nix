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
, sqlite
, systemd
, unbound
, zeromq
}:

stdenv.mkDerivation rec {
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
    spdlog
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
