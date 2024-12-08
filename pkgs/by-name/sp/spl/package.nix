{
  lib,
  fetchgit,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "spl";
  version = "0.4.2";

  passthru.updateScript = nix-update-script { };

  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/spl";
    rev = "v${version}";
    hash = "sha256-cU6qSh4HM3os/A1w0+5TSZLkS2Y/C864qvmixkxPAh8=";
  };

  cargoHash = "sha256-AWkyh3MRtnK+IzXu+h6jurNVMLDQVlBs2RsS2jn9lrA=";

  meta = {
    description = "Simple, concise, concatenative scripting language";
    homepage = "https://git.tudbut.de/tudbut/spl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "spl";
  };
}
