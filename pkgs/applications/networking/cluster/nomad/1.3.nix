{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.3.7";
  sha256 = "sha256-hMMR7PdCViZdePXy9aFqTFBxoiuuXqIldXyCGkkr5MA=";
  vendorSha256 = "sha256-unw2/E048jzDHj7glXc61UNZIr930UpU9RrXI6DByj4=";
}
