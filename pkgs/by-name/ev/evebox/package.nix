{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "evebox";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "jasonish";
    repo = "evebox";
    rev = version;
    hash = "sha256-vakCBDyL/Su55tkn/SJ5ShZcYC8l+p2acpve/fTN0uI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "suricatax-rule-parser-0.1.0" = "sha256-qwkZFmvgfXrH0zHPq/dVfxpWkulPDT+CzPQQHfeBotg=";
    };
  };

  meta = {
    description = "Web Based Event Viewer (GUI) for Suricata EVE Events in Elastic Search";
    homepage = "https://evebox.org/";
    changelog = "https://github.com/jasonish/evebox/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
