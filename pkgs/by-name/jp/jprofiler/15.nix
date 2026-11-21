{
  callPackage,
  jdk21,
}:

callPackage ./common.nix {
  version = "15.0.4";
  jdk = jdk21;
  icon = "i4j_extf_12_v3vxop_wkw4tw.png";
  hashes = {
    linux = "sha256-/sdBcYhUoRsjg7snjKcQOYTgrmWSaO1T6lqLMgd7hsk=";
    darwin = "sha256-FCsyMnZ/DEZFTN7/MebJsCcPaM8ODGntdeezZcETA5s=";
  };
}
