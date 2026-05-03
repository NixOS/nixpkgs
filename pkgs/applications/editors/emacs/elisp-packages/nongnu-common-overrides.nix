pkgs: lib:

self: super:

let
  inherit (import ./lib-override-helper.nix pkgs lib)
    addPackageRequires
    ;
in
{
  # keep-sorted start block=yes newline_separated=yes
  # missing optional dependencies
  haskell-tng-mode = addPackageRequires super.haskell-tng-mode (
    with self;
    [
      s
      company
      projectile
      smartparens
      yasnippet
    ]
  );
  # keep-sorted end
}
