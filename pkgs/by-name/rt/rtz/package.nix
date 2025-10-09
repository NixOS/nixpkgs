{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "rtz";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "twitchax";
    repo = "rtz";
    rev = "v${version}";
    hash = "sha256-V7N9NFIc/WWxLaahkjdS47Qj8sc3HRdKSkrBqi1ngA8=";
  };

  cargoHash = "sha256-Lm81Qnu3ZQw43fCcQOR63EV1aYXuPyR9Gy+F6BCiwUw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    openssl
    zstd
  ];

  buildFeatures = [ "web" ];

  meta = with lib; {
    description = "Tool to easily work with timezone lookups via a binary, a library, or a server";
    homepage = "https://github.com/twitchax/rtz";
    changelog = "https://github.com/twitchax/rtz/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rtz";
  };
}
