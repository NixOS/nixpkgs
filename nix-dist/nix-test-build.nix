{stdenv, getopt, src}:

derivation {
  name = "nix-test-build";
  system = stdenv.system;

  builder = ./nix-test-build.sh;
  src = src;

  stdenv = stdenv;
  getopt = getopt; # required by sdf2table
}
