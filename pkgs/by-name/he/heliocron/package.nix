{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "heliocron";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mfreeborn";
    repo = "heliocron";
    rev = "v${version}";
    hash = "sha256-tqwVYIU8RXb1hiKnP7AlkxHsMhbAlwSmPGyFFMHIbAo=";
  };

  cargoHash = "sha256-rQriNb/njEUBUmCUy5NKEfOYkOLy9i7ClU0vR72udOo=";

  meta = {
    description = "Execute tasks relative to sunset, sunrise and other solar events";
    longDescription = "A simple command line application that integrates with `cron` to execute tasks relative to sunset, sunrise and other such solar events.";
    homepage = "https://github.com/mfreeborn/heliocron";
    changelog = "https://github.com/mfreeborn/heliocron/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ TheColorman ];
    mainProgram = "heliocron";
    platforms = lib.platforms.linux;
  };
}
