{ invalidateFetcherByDrvHash, fetchgit, ... }:

{
  simple = invalidateFetcherByDrvHash fetchgit {
    name = "nix-source";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sha256 = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
  };

  sparseCheckout = invalidateFetcherByDrvHash fetchgit {
    name = "nix-source";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sparseCheckout = ''
      src
      tests
    '';
    sha256 = "sha256-FknO6C/PSnMPfhUqObD4vsW4PhkwdmPa9blNzcNvJQ4=";
  };
}
