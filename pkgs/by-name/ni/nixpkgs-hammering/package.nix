{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  nix,
  unstableGitUpdater,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-hammering";
  version = "0-unstable-2025-09-10";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "8cb86601cfa5521b454974d7219924f2d1c304c9";
    hash = "sha256-9rSdimO591tpfe3MpcHkqsc0lPk6roNwgj6ajVSOG7E=";
  };

  cargoHash = "sha256-MRwmeR5rj0PWUF5VMW5+9BbcX7Pq82YhufUv2Gt107U=";

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    datadir="$out/share/nixpkgs-hammering"
    mkdir -p "$datadir"

    wrapProgram "$out/bin/nixpkgs-hammer" \
        --prefix PATH ":" ${lib.makeBinPath [ nix ]} \
        --set OVERLAYS_DIR "$datadir/overlays"
    cp -r ./overlays "$datadir/overlays"
    cp -r ./lib "$datadir/lib"
  '';

  # running checks requires to run nix inside of the builder which fails due to permission errors
  doCheck = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Set of nit-picky rules that aim to point out and explain common mistakes in nixpkgs package pull requests";
    homepage = "https://github.com/jtojnar/nixpkgs-hammering";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-hammer";
    maintainers = with lib.maintainers; [ figsoda ];
  };
})
