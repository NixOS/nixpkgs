{ stdenv
, cmake
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
  version = "1.8";

  src = fetchFromGitHub {
    owner = "SChernykh";
    repo = "p2pool";
    rev = "v${version}";
    sha256 = "sha256-cQd3dtih7C+pEmkvlrsYTJtQWBVVMiFbtNQUM0Ck3tg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libuv zeromq libsodium gss hwloc openssl ];

  installPhase = ''
    runHook preInstall

    install -vD p2pool $out/bin/p2pool

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Decentralized pool for Monero mining";
    homepage = "https://github.com/SChernykh/p2pool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ratsclub ];
  };
}
