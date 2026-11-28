{
  callPackage,
  jdk11,
}:

callPackage ./common.nix {
  version = "14.0.6";
  jdk = jdk11;
  icon = "i4j_extf_6_1u09tly_92xp8q.png";
  hashes = {
    linux = "sha256-dPRuqvyn/xc1zwWyWhn7lgX4E1UcBFA6AyZVXsWQejc=";
    darwin = "sha256-rlAktkSUomh9xO7xHRiBMfPoQS4YVmYp/PClOe4PfqE=";
  };
}
