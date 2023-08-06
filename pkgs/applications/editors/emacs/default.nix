{ lib, pkgs }:

lib.makeScope pkgs.newScope (self:
  let
    gconf = pkgs.gnome2.GConf;
    inherit (self) callPackage;
  in {
    sources = import ./sources.nix {
      inherit lib;
      inherit (pkgs)
        fetchFromBitbucket
        fetchFromSavannah;
    };

    emacs28 = callPackage (self.sources.emacs28) {
      inherit gconf;

      inherit (pkgs.darwin) sigtool;
      inherit (pkgs.darwin.apple_sdk.frameworks)
        AppKit Carbon Cocoa GSS ImageCaptureCore ImageIO IOKit OSAKit Quartz
        QuartzCore WebKit;
    };

    emacs28-gtk2 = self.emacs28.override {
      withGTK2 = true;
    };

    emacs28-gtk3 = self.emacs28.override {
      withGTK3 = true;
    };

    emacs28-nox = pkgs.lowPrio (self.emacs28.override {
      noGui = true;
    });

    emacs29 = callPackage (self.sources.emacs29) {
      inherit gconf;

      inherit (pkgs.darwin) sigtool;
      inherit (pkgs.darwin.apple_sdk.frameworks)
        AppKit Carbon Cocoa GSS ImageCaptureCore ImageIO IOKit OSAKit Quartz
        QuartzCore WebKit;
    };

    emacs29-gtk3 = self.emacs29.override {
      withGTK3 = true;
    };

    emacs29-nox = self.emacs29.override {
      noGui = true;
    };

    emacs29-pgtk = self.emacs29.override {
      withPgtk = true;
    };

    emacs-macport = callPackage (self.sources.emacs-macport) {
      inherit gconf;

      inherit (pkgs.darwin) sigtool;
      inherit (pkgs.darwin.apple_sdk.frameworks)
        AppKit Carbon Cocoa GSS ImageCaptureCore ImageIO IOKit OSAKit Quartz
        QuartzCore WebKit;
    };
  })
