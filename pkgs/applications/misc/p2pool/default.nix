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
  version = "4.1";

  src = fetchFromGitHub {
    owner = "SChernykh";
    repo = "p2pool";
    rev = "v${version}";
    hash = "sha256-eMg8DXFtVfYhl6vpg/KRUZUgMU/XsCS29Af1CSIbUsY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libuv zeromq libsodium gss hwloc openssl curl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation ];

  cmakeFlags = ["-DWITH_LTO=OFF"];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13") [
    "-faligned-allocation"
  ]);

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
    mainProgram = "p2pool";
    platforms = platforms.all;
  };
}
