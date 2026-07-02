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
  version = "0-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "0ca8e718c6809e0c2b640b954bfe000b915634dc";
    hash = "sha256-j/jqwdM466jE2Rf6aW3DfI6wQa44eN8W8/ii1aX8HDs=";
  };

  cargoHash = "sha256-Lmj9XWUUavlmZn/IK+CcXQhKUYfz3dKF6S2U3BMhoIc=";

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
