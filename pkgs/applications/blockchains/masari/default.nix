{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, unbound, openssl, boost
, lmdb, miniupnpc, readline, git, libsodium, rapidjson, cppzmq }:

stdenv.mkDerivation rec {
  pname = "masari";
  version = "unstable-2022-10-09";

  src = fetchFromGitHub {
    owner = "masari-project";
    repo = "masari";
    rev = "ff71f52220858b84a4403dab9a14339bcad57826";
    sha256 = "sha256-GunNFqZNgpLfyAA9BiBC98axgTQuK76z3BUl5T0iJqs=";
  };

  postPatch = ''
    # remove vendored libraries
    rm -r external/{miniupnpc,rapidjson}
  '';

  nativeBuildInputs = [ cmake pkg-config git ];

  buildInputs = [
    boost miniupnpc openssl unbound
    readline libsodium
    rapidjson cppzmq
  ];

  meta = with lib; {
    description = "scalability-focused, untraceable, secure, and fungible cryptocurrency using the RingCT protocol";
    homepage = "https://www.getmasari.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
  };
}
