{ stdenv
, cmake
, curl
, fetchFromGitHub
, gss
, hwloc
, lib
, libsodium
, libuv
, nix-update-script
, openssl
, pkg-config
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "p2pool";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "SChernykh";
    repo = "p2pool";
    rev = "v${version}";
    sha256 = "sha256-En2ogxAD61w7DRTsCGIp6fEP/cC2A+pTYIbjeJ1MktY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libuv zeromq libsodium gss hwloc openssl curl ];

  installPhase = ''
    runHook preInstall

    install -vD p2pool $out/bin/p2pool

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Decentralized pool for Monero mining";
    homepage = "https://github.com/SChernykh/p2pool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ratsclub ];
  };
}
