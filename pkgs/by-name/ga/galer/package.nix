{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "galer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = "galer";
    tag = "v${version}";
    hash = "sha256-otyvEXBiPBhWvyoJEG6Ho5HA63Lg78odMR4mc0n+xXo=";
  };

  vendorHash = "sha256-BS7ZUq8/swZpTaYGjiF5OuZXQpoosZ3mdF9v1euijxo=";

  meta = {
    description = "Tool to fetch URLs from HTML attributes";
    homepage = "https://github.com/dwisiswant0/galer";
    changelog = "https://github.com/dwisiswant0/galer/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "galer";
  };
}
