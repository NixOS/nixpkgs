{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "crab-hole";
  version = "0.1.9-unstable-2024-09-05";

  src = fetchFromGitHub {
    owner = "LuckyTurtleDev";
    repo = pname;
    rev = "259b8a00e2a672ed4a4d09ad660c88b06c5b2a6b"; # Version 0.1.9 + fixed warning
    hash = "sha256-N/jfNC55WcbhZtmNfPy9oszntmlz8IhDgitNOaKCdI4=";
  };

  cargoHash = "sha256-B3FSKV7fVWdZ8r53fUtqZV7tyVVsP9CzwvoDCqfR42M=";

  meta = {
    description = "Pi-Hole clone written in rust using hickory-dns/trust-dns";
    homepage = "https://github.com/LuckyTurtleDev/crab-hole";
    license = lib.licenses.agpl3Plus;
    mainProgram = "crab-hole";
    maintainers = [
      lib.maintainers.NiklasVousten
    ];
    platforms = lib.platforms.all;
  };
}
