{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.0.0-beta1";
  kde-channel = "unstable";
  sha256 = "1p5l2vpsgcp4wajgn5rgjcyb8l5ickm1nkmfx8zzr4rnwjnyxdbm";
})
