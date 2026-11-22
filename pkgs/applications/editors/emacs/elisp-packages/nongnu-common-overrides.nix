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

  # requires optional dependency for OMEMO support.
  jabber = super.jabber.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ pkgs.mbedtls ];
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.pkg-config ];

    # We need to run this in postInstall for package directory to become available
    postInstall =
      (old.postInstall or "")
      + "\n"
      + ''
        pushd $out/share/emacs/site-lisp/elpa/jabber-*/src
        make CC=$CC
        rm -r $out/share/emacs/site-lisp/elpa/jabber-*/src
        popd
      '';
  });
  # keep-sorted end
}
