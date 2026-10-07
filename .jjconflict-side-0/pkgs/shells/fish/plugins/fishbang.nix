{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin {
  pname = "fishbang";
  version = "0-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "BrewingWeasel";
    repo = "fishbang";
    rev = "f8d2721ac5508dbda54a666ebf12f1492c478277";
    hash = "sha256-VHtjt3Xobvs0DTXJ1mFU8i84EEsNQv3yqbhjs7c1mNE=";
  };

  meta = {
    description = "Bash bang commands for fish";
    homepage = "https://github.com/BrewingWeasel/fishbang";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.marcel ];
  };
}
