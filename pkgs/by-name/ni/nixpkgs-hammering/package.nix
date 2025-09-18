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
  version = "0-unstable-2025-02-09";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "df77e6533c21737e5976c6fe4a4d81d7dcfc3e0e";
    hash = "sha256-Nr/4WcBMA/fc9WfNECB/nM85JfT2xwQYwS7Jq6rGKoM=";
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
