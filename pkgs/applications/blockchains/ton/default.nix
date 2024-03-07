{ lib
, stdenv
, fetchFromGitHub
, cmake
, git
, pkg-config
, gperf
, libmicrohttpd
, openssl
, readline
, zlib
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "ton";
  version = "2023.10";

  src = fetchFromGitHub {
    owner = "ton-blockchain";
    repo = "ton";
    rev = "v${version}";
    sha256 = "sha256-K1RhhW7EvwYV7/ng3NPjSGdHEQvJZ7K97YXd7s5wghc=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    gperf
    libmicrohttpd
    openssl
    readline
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A fully decentralized layer-1 blockchain designed by Telegram";
    homepage = "https://ton.org/";
    changelog = "https://github.com/ton-blockchain/ton/blob/v${version}/Changelog.md";
    license = licenses.lgpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
