{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  xorg,
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
    xorg.libX11
  ];

  meta = with lib; {
    description = "Livesplit-inspired speedrunning split timer for Linux/macOS terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/alexozer/flitter";
    platforms = platforms.unix;
    mainProgram = "flitter";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
