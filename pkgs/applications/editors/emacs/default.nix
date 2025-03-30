{ lib, pkgs }:

lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
    inheritedArgs = {
      inherit (pkgs.darwin) sigtool;
      inherit (pkgs.darwin.apple_sdk.frameworks)
        Accelerate
        AppKit
        Carbon
        Cocoa
        GSS
        ImageCaptureCore
        ImageIO
        IOKit
        OSAKit
        Quartz
        QuartzCore
        WebKit
        ;
      inherit (pkgs.darwin.apple_sdk_11_0.frameworks) UniformTypeIdentifiers;
    };
  in
  {
    sources = import ./sources.nix {
      inherit lib;
      inherit (pkgs)
        fetchFromBitbucket
        fetchFromSavannah
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

    emacs28-macport = callPackage (self.sources.emacs28-macport) inheritedArgs;

    emacs29-macport = callPackage (self.sources.emacs29-macport) inheritedArgs;
  }
)
