{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.2.14";
  sha256 = "sha256-BEbRXakMbgE44z1NOGThUuT1FukFUc1cnPkV5PXAY+4=";
  vendorSha256 = "sha256-bOJ/qlvY3NHlR9C08vwfVn4Z/bSH15EPs3vvq78JoKs=";
}
