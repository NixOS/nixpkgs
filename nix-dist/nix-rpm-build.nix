{stdenv, getopt, src}:

derivation {
  name = "nix-rpm-build";
  system = stdenv.system;

  builder = ./nix-rpm-build.sh;
  src = src;

  stdenv = stdenv;
  getopt = getopt; # required by sdf2table

  # Perhaps it's possible to build RPMs in a pure way?  Probably not,
  # since RPM needs its database to determine dependencies.
  rpm = "/bin/rpm";
}
