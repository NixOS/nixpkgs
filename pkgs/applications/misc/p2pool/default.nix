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
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) Foundation;
in
stdenv.mkDerivation rec {
  pname = "p2pool";
<<<<<<< HEAD
  version = "3.5";
=======
  version = "3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SChernykh";
    repo = "p2pool";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-qwdEmDfH+TE0WF2HIVCn23RlzelLBvCOu9VKpScdO68=";
=======
    sha256 = "sha256-sCG2Dr0gDznOyuSCVm/Zop+64elUZLt+XSDff2jQlwg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libuv zeromq libsodium gss hwloc openssl curl ]
    ++ lib.optionals stdenv.isDarwin [ Foundation ];

  cmakeFlags = ["-DWITH_LTO=OFF"];

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
