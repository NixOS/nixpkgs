{
  description = "Library of low-level helper functions for nix expressions.";

  outputs = { self }: { lib = import ./.; };
}
