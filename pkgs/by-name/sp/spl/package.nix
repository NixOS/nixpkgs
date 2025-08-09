{
  lib,
  fetchgit,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "spl";
  version = "0.4.3";

  passthru.updateScript = nix-update-script { };

  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/spl";
    rev = "v${version}";
    hash = "sha256-ckj50psQ2/r7Bw03J2VjHx0R1zY5xivJfvB9HNxnJLw=";
  };

  cargoHash = "sha256-rq6GO+5qXM22JoAGdAM3Bb6/U0+x5sRYUjnZQUpzcGA=";

  meta = {
    description = "Simple, concise, concatenative scripting language";
    homepage = "https://git.tudbut.de/tudbut/spl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "spl";
  };
}
