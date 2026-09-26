{
  lib,
  symlinkJoin,
  cabal2nix-unwrapped,
  makeWrapper,
  nix-prefetch-scripts,
}:

symlinkJoin {
  inherit (cabal2nix-unwrapped) pname version meta;
  nativeBuildInputs = [ makeWrapper ];
  paths = [ cabal2nix-unwrapped ];
  postBuild = ''
    wrapProgram $out/bin/cabal2nix \
      --prefix PATH ":" "${
        lib.makeBinPath [
          nix-prefetch-scripts
        ]
      }"
  '';
}
