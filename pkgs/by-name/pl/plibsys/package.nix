{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plibsys";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "saprykin";
    repo = "plibsys";
    rev = finalAttrs.version;
    hash = "sha256-KOHqV2T8mB0s1n+lnxlf9+QxZhkzvZlRk7m3SqGpb4I=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/saprykin/plibsys";
    description = "Highly portable C system library: threads and synchronization, sockets, IPC, data structures and more";
    license = licenses.mit;
    maintainers = with maintainers; [ rs0vere ];
    platforms = platforms.all;
  };
})
