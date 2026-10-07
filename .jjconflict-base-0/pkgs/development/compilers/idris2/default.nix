{ callPackage, idris2 }:
{
  inherit idris2;
  idris2Api = callPackage ./idris2-api.nix { };
  idris2Lsp = callPackage ./idris2-lsp.nix { };

  pack = callPackage ./pack.nix { };

  buildIdris = callPackage ./build-idris.nix { };
}
