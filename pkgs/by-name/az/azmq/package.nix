{
  lib,
  stdenv,
  fetchFromGitHub,
  boost183,
  cmake,
  ninja,
  zeromq,
  catch2,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "azmq";
  version = "1.0.3-unstable-2025-01-19";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "azmq";
    rev = "4e8f18bf3ac60f5c8126db61e48927ea19a88195";
    hash = "sha256-0TYZvQefoW77RXhQ57niXs3Kcz2YHW9cBDNGFU47BBs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    boost183
    catch2
    zeromq
  ];

  # Broken for some reason on this platform.
  doCheck = !(stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux);

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/zeromq/azmq";
    license = licenses.boost;
    description = "C++ language binding library integrating ZeroMQ with Boost Asio";
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
