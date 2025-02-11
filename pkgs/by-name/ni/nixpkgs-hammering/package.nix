{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  makeWrapper,
  python3,
  nix,
  unstableGitUpdater,
}:

let
  version = "0-unstable-2024-12-22";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "56e8d636b3e7188dae2832fc405db2e388be634b";
    hash = "sha256-hr+BHAmWT/FCLI5zNEHgtKdBbIYgmAydrErRu9RfuuM=";
  };

  meta = with lib; {
    description = "Set of nit-picky rules that aim to point out and explain common mistakes in nixpkgs package pull requests";
    homepage = "https://github.com/jtojnar/nixpkgs-hammering";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };

  rust-checks = rustPlatform.buildRustPackage {
    pname = "nixpkgs-hammering-rust-checks";
    inherit version src meta;
    sourceRoot = "${src.name}/rust-checks";
    useFetchCargoVendor = true;
    cargoHash = "sha256-cE1fzdxGa0WG2WCPs8UFnE2vzaKfU7r6LS+9HLCVJ1U=";
  };
in

stdenv.mkDerivation {
  pname = "nixpkgs-hammering";

  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    AST_CHECK_NAMES=$(find ${rust-checks}/bin -maxdepth 1 -type f -printf "%f:")

    install -Dt $out/bin tools/nixpkgs-hammer
    wrapProgram $out/bin/nixpkgs-hammer \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          rust-checks
        ]
      } \
      --set AST_CHECK_NAMES ''${AST_CHECK_NAMES%:}

    cp -r lib overlays $out

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = meta // {
    mainProgram = "nixpkgs-hammer";
  };
}
