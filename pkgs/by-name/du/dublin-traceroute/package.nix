{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, jsoncpp, libtins, libpcap, openssl, unstableGitUpdater, nixosTests }:

stdenv.mkDerivation {
  pname = "dublin-traceroute";
  version = "0.4.2-unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "insomniacslk";
    repo = "dublin-traceroute";
    rev = "2fb78ea05596dfdf8f7764b497eb8d3a812cb695";
    hash = "sha256-E1HYMd0wDTfAZ0TamQFazh8CPhMa2lNIbF4aEBf5qhk=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ jsoncpp libtins libpcap openssl ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru = {
    # 0.4.2 was tagged in 2017
    updateScript = unstableGitUpdater { };

    tests = {
      inherit (nixosTests) dublin-traceroute;
    };
  };

  meta = with lib; {
    description = "NAT-aware multipath traceroute tool";
    homepage = "https://dublin-traceroute.net/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ baloo ];
    platforms = platforms.unix;
    mainProgram = "dublin-traceroute";
  };
}
