{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.4.3";
  sha256 = "sha256-GQVfrn9VlzfdIj73W3hBpHcevsXZcb6Uj808HUCZUUg=";
  vendorSha256 = "sha256-JQRpsQhq5r/QcgFwtnptmvnjBEhdCFrXFrTKkJioL3A=";
}
