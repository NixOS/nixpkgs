{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "heh";
<<<<<<< HEAD
  version = "0.6.2";
=======
  version = "0.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ndd7xv";
    repo = "heh";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Yjq4w0xaFNCKJBxXT9dXaJQQ9YYN/5DZ32DJgsvuIsU=";
  };

  cargoHash = "sha256-D0rO/W37eEfstSUwCp42DC0bAyTbyXDGIZVdRbhP4gQ=";

  meta = {
    description = "Cross-platform terminal UI used for modifying file data in hex or ASCII";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ piturnah ];
=======
    hash = "sha256-eqWBTylvXqGhWdSGHdTM1ZURSD5pkUBoBOvBJ5zmJ7w=";
  };

  cargoHash = "sha256-Sk/eL5Pza9L8GLBxqL9SqMT7KDWZenMjV+sGYaWUnzo=";

  meta = with lib; {
    description = "Cross-platform terminal UI used for modifying file data in hex or ASCII";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ piturnah ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "heh";
  };
}
