{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, jsoncpp, libtins, libpcap, openssl, unstableGitUpdater, nixosTests }:

stdenv.mkDerivation {
  pname = "dublin-traceroute";
  version = "0.4.2-unstable-2024-01-09";

  src = fetchFromGitHub {
    owner = "insomniacslk";
    repo = "dublin-traceroute";
    rev = "b136db81cfbb30d5fd324dfccc97fca49a5ecee1";
    hash = "sha256-FsolpeQGaLDjDE5Yk58t2hFQJgM58zafIx6s5ejYKnY=";
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
