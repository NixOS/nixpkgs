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
  version = "0-unstable-2026-10-04";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "04d6db9304fb08ffaf3d5780a8bb3da908f5ca69";
    hash = "sha256-o0j00H8IQYmhKknJZdMhWEU5PRTOCXyOIyB3tz43Tz8=";
  };

  cargoHash = "sha256-IiZzJt7t5PlErciIU6r6fSKsWEJMZfqnPAqiX3G3BqU=";

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
