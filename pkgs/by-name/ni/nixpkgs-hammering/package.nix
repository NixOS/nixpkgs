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
  version = "0-unstable-2026-10-22";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "d4ec1603edd83c8081529eae1f58bc02246aca5c";
    hash = "sha256-dAM3b8rJ831aQU3BKHjVrm8+4n/fbVpFeMuKqLSGD+k=";
  };

  cargoHash = "sha256-aBSwZOsRB1b/NrlqMfUWPazyeDA6YOEQQ5vOzpEwd/w=";

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
