{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libx11,
}:

rustPlatform.buildRustPackage rec {
  pname = "flitter";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "alexozer";
    repo = "flitter";
    tag = version;
    hash = "sha256-aXTQeUKhwa2uVipKIs8n0XBiWa5o7U6UMlAUlnzXyzE=";
  };

  cargoHash = "sha256-SOmq1txYMJGUVkkrE3kWmioaJzBX9raZ+ExFlPYGDM8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libx11
  ];

  meta = {
    description = "Livesplit-inspired speedrunning split timer for Linux/macOS terminal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    homepage = "https://github.com/alexozer/flitter";
    platforms = lib.platforms.unix;
    mainProgram = "flitter";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
