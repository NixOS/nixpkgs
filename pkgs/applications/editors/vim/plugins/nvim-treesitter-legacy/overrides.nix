{ lib }:
self: super:
let
  inherit (self) nvim-treesitter;

  withPlugins =
    f:
    let
      from-main = self.nvim-treesitter.withPlugins f;
    in
    self.nvim-treesitter-legacy.overrideAttrs {
      passthru = { inherit (from-main) dependencies; };
    };

  withAllGrammars = withPlugins (_: nvim-treesitter.allGrammars);
in

{
  postPatch = ''
    rm -r parser
  '';

  passthru = (super.nvim-treesitter-legacy.passthru or { }) // {
    inherit (nvim-treesitter)
      builtGrammars
      allGrammars
      grammarToPlugin
      grammarPlugins
      parsers
      ;
    inherit
      withPlugins
      withAllGrammars
      ;
  };

  meta = super.nvim-treesitter-legacy.meta or { } // {
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
