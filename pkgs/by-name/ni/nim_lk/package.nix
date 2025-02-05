{
  lib,
  buildNimSbom,
  fetchFromSourcehut,
  nim,
  nix-prefetch,
  nix-prefetch-git,
  openssl,
  makeWrapper,
}:

let
  nimUnwrapped = nim.passthru.nim;
in
buildNimSbom (finalAttrs: {
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_lk";
    rev = finalAttrs.version;
    hash = "sha256-1WD1UVi6N7tftE69LAhx86Qxc97oMHKARFsCVGqtEm4=";
  };

  buildInputs = [ openssl ];
  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/nim_lk \
      --suffix PATH : ${
        lib.makeBinPath [
          nimUnwrapped
          nix-prefetch
          nix-prefetch-git
        ]
      }
  '';

  meta = finalAttrs.src.meta // {
    description = "Generate Nix specific lock files for Nim packages";
    homepage = "https://git.sr.ht/~ehmry/nim_lk";
    mainProgram = "nim_lk";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}) ./sbom.json
