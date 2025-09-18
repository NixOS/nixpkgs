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

  p4-16-mode = super.p4-16-mode.overrideAttrs {
    # workaround https://github.com/NixOS/nixpkgs/issues/301795
    prePatch = ''
      mkdir tmp-untar-dir
      pushd tmp-untar-dir

      tar --extract --verbose --file=$src
      content_directory=$(echo p4-16-mode-*)
      cp --verbose $content_directory/p4-16-mode-pkg.el $content_directory/p4-pkg.el
      src=$PWD/$content_directory.tar
      tar --create --verbose --file=$src $content_directory

      popd
    '';
  };
  # keep-sorted end
}
