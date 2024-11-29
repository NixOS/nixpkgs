{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, jsoncpp, libtins, libpcap, openssl, unstableGitUpdater, nixosTests }:

stdenv.mkDerivation {
  pname = "dublin-traceroute";
  version = "0.4.2-unstable-2024-04-11";

  src = fetchFromGitHub {
    owner = "insomniacslk";
    repo = "dublin-traceroute";
    rev = "a92118d93fd1fa7bdb827e741dd848b7f7083a1e";
    hash = "sha256-UJeFPVi3423Jh72fVk8QbLX1tTNAQ504xYs9HwVCkZc=";
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
    broken = stdenv.hostPlatform.isDarwin;
  };
}
