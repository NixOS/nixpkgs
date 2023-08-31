{ lib, pkgs }:

lib.makeScope pkgs.newScope (self:
  let
    gconf = pkgs.gnome2.GConf;
    inherit (self) callPackage;
    inheritedArgs = {
      inherit gconf;

      inherit (pkgs.darwin) sigtool;
      inherit (pkgs.darwin.apple_sdk_11_0.frameworks)
        Accelerate AppKit Carbon Cocoa GSS ImageCaptureCore ImageIO IOKit OSAKit
        Quartz QuartzCore UniformTypeIdentifiers WebKit;
    };
  in {
    sources = import ./sources.nix {
      inherit lib;
      inherit (pkgs)
        fetchFromBitbucket
        fetchFromSavannah;
    };

    emacs28 = callPackage (self.sources.emacs28) inheritedArgs;

    emacs28-gtk2 = self.emacs28.override {
      withGTK2 = true;
    };

    emacs28-gtk3 = self.emacs28.override {
      withGTK3 = true;
    };

    emacs28-nox = pkgs.lowPrio (self.emacs28.override {
      noGui = true;
    });

    emacs29 = callPackage (self.sources.emacs29) inheritedArgs;

    emacs29-gtk3 = self.emacs29.override {
      withGTK3 = true;
    };

    emacs29-nox = self.emacs29.override {
      noGui = true;
    };

    emacs29-pgtk = self.emacs29.override {
      withPgtk = true;
    };

    emacs28-macport = callPackage (self.sources.emacs28-macport) inheritedArgs;

    emacs29-macport = callPackage (self.sources.emacs29-macport) inheritedArgs;
  })
