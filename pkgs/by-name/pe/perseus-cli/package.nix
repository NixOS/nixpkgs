{
  lib,
  rustPlatform,
  fetchCrate,
  makeWrapper,
  wasm-pack,
}:

rustPlatform.buildRustPackage rec {
  pname = "perseus-cli";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IYjLx9/4oWSXa4jhOtGw1GOHmrR7LQ6bWyN5zbOuEFs=";
  };

  cargoHash = "sha256-9McjhdS6KrFgtWIaP0qKsUYpPxGQjNX7SM9gJ/aJGwc=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/perseus \
      --prefix PATH : "${lib.makeBinPath [ wasm-pack ]}"
  '';

  meta = with lib; {
    homepage = "https://framesurge.sh/perseus/en-US";
    description = "High-level web development framework for Rust with full support for server-side rendering and static generation";
    maintainers = with maintainers; [ max-niederman ];
    license = with licenses; [ mit ];
    mainProgram = "perseus";
  };
}
