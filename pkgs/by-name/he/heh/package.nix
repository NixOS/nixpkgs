{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "heh";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "ndd7xv";
    repo = "heh";
    rev = "v${version}";
    hash = "sha256-Fo8hsa1+H97t/f90hDNyQOXKGbLVPv2/r5erlHXALbc=";
  };

  cargoHash = "sha256-xUhz9tKfqclYL6ztOA45lsQE+0MJAO+LNqy8B9c8MGw=";

  meta = {
    description = "Cross-platform terminal UI used for modifying file data in hex or ASCII";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ piturnah ];
    mainProgram = "heh";
  };
}
