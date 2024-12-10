{
  lib,
  buildNimPackage,
  fetchFromSourcehut,
  nim,
  nix-prefetch,
  nix-prefetch-git,
  openssl,
  makeWrapper,
}:

let
  nim' = nim.passthru.nim;
in
buildNimPackage (finalAttrs: {
  pname = "nim_lk";
  version = "20240527";

  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_lk";
    rev = finalAttrs.version;
    hash = "sha256-r8K9HRGEgqlFZJPdDeOYienmfzfNOeCdqMhshjr72Ok=";
  };

  lockFile = ./lock.json;

  buildInputs = [ openssl ];
  nativeBuildInputs = [ makeWrapper ];

  nimFlags = [ "--path:${nim'}/nim" ];

  postFixup = ''
    wrapProgram $out/bin/nim_lk \
      --suffix PATH : ${
        lib.makeBinPath [
          nim'
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
})
