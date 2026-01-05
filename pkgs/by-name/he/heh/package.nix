{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "heh";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ndd7xv";
    repo = "heh";
    rev = "v${version}";
    hash = "sha256-Yjq4w0xaFNCKJBxXT9dXaJQQ9YYN/5DZ32DJgsvuIsU=";
  };

  cargoHash = "sha256-D0rO/W37eEfstSUwCp42DC0bAyTbyXDGIZVdRbhP4gQ=";

  meta = {
    description = "Cross-platform terminal UI used for modifying file data in hex or ASCII";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ piturnah ];
    mainProgram = "heh";
  };
}
