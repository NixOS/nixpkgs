{
  lib,
  fetchgit,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "spl";
  version = "0.4.1";

  passthru.updateScript = nix-update-script { };

  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/spl";
    rev = "v${version}";
    hash = "sha256-ZYx8KeJ6B7Dgf1RrTQbW6fI/DjuuZksiyEePMNmGigA=";
  };

  cargoHash = "sha256-2vDX7ltYT+bsVLNDslYzs6FZ6Mplsz9RRQpMg+nigtU=";

  meta = {
    description = "Simple, concise, concatenative scripting language";
    homepage = "https://git.tudbut.de/tudbut/spl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "spl";
  };
}
