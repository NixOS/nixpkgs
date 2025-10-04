{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libevent,
  libsodium,
  libuv,
  nlohmann_json,
  pkg-config,
  spdlog,
  sqlite,
  systemd,
  unbound,
  zeromq,
}:

stdenv.mkDerivation rec {
  pname = "lokinet";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "oxen-io";
    repo = "lokinet";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-6TVMuT4O8zJj97873BTsR1PJU8NaBgYr/nBkc/EfQuQ=";
  };

  patches = [
    # Fix gcc-13 compatibility:
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/oxen-io/lokinet/commit/89c5c73be48788ba14a55cb6d82d57208b487eaf.patch";
      hash = "sha256-yCy4WXs6p67TMe4uPNAuQyJvtP3IbpJS81AeomNu9lU=";
    })
  ];

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

  meta = {
    # Upstream has received reports of incompatibilities with fmt, and other
    # dependencies, see: https://github.com/oxen-io/lokinet/issues/2200.
    # But our version of spdlog doesn't support fmt_9
    broken = true;
    description = "Anonymous, decentralized and IP based overlay network for the internet";
    homepage = "https://lokinet.org/";
    changelog = "https://github.com/oxen-io/lokinet/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wyndon ];
  };
}
