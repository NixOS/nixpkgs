{
  lib,
  clang,
  libclang,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "blockstream-electrs";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "blockstream";
    repo = "electrs";
    rev = "72d88dd4e9b6c68c3f03c08b9847bde3d22025c8";
    hash = "sha256-fQ1CQ+7mZF8zQBkH2ARcjlXuIdI+csSuxMS5ggTVgnA=";
  };

  LIBCLANG_PATH = "${libclang.lib}/lib";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "electrum-client-0.8.0" = "sha256-HDRdGS7CwWsPXkA1HdurwrVu4lhEx0Ay8vHi08urjZ0=";
      "electrumd-0.1.0" = "sha256-s1/laailcwOmqjAPJnuqe7Y45Bvxwqw8EjKN54BS5gI=";
      "jsonrpc-0.12.0" = "sha256-lSNkkQttb8LnJej4Vfe7MrjiNPOuJ5A6w5iLstl9O1k=";
    };
  };
  cargoBuildFlags = "--bin electrs";

  # the tests require binary downloads for dependent services
  doCheck = false;

  nativeBuildInputs = [clang];

  meta = with lib; {
    description = "Blockstream fork of Electrs specialized for high load";
    homepage = "https://github.com/Blockstream/electrs";
    license = with licenses; [mit];
    maintainers = with maintainers; [delta1];
    mainProgram = "electrs";
  };
}
