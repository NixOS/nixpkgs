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
  version = "1.0.3-unstable-2025-11-30";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "azmq";
    rev = "819b24035cfa5b73081e21f5867445f2344f680d";
    hash = "sha256-jOdggbO+A0ituGmhdpvvBGGNmudmdVlbUJJzEpXILVE=";
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
