{ lib, pkgs }:

lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
    inheritedArgs = {
      inherit (pkgs.darwin) sigtool;
    };
  in
  {
    sources = import ./sources.nix {
      inherit lib;
      inherit (pkgs)
        fetchFromGitHub
        fetchzip
        ;
    };

    emacs30 = callPackage (self.sources.emacs30) inheritedArgs;

    emacs30-gtk3 = self.emacs30.override {
      withGTK3 = true;
    };

    emacs30-nox = self.emacs30.override {
      noGui = true;
    };

    emacs30-pgtk = self.emacs30.override {
      withPgtk = true;
    };

    emacs30-macport = callPackage (self.sources.emacs30-macport) (
      inheritedArgs
      // {
        srcRepo = true;
      }
    );
  }
)
