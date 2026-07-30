{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  nix,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-hammering";
  version = "0-unstable-2026-07-20";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "d131eb5c4d92c9b12001f8ff6ee79fcad4dc4f32";
    hash = "sha256-rzmyA5s+7vlDazKCJSVy3bJH0ql/ekc7B2zsG+8YXLk=";
  };

  cargoHash = "sha256-0xk/HIK9urjhjotQaNzEJ5CRj50jZlsNOsTCHbfCdy8=";

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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Set of nit-picky rules that aim to point out and explain common mistakes in nixpkgs package pull requests";
    homepage = "https://github.com/jtojnar/nixpkgs-hammering";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-hammer";
    maintainers = with lib.maintainers; [ iamanaws ];
  };
})
