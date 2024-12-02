import ./generic.nix {
  hash = "sha256-k7DHJRbhUJwamEOW8B7wdCWQyYEUtsIHwuHh20lpLmA=";
  version = "6.7.0";
  vendorHash = "sha256-u12zYcKiHNUH1kWpkMIyixtK9t+G4N2QerzOGsujjFQ=";
  patches = [ ./1377-reverse.patch ];
}
