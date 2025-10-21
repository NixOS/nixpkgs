{
  lib,
  fetchFromGitHub,
}:
fetchFromGitHub {
  pname = "rust-advisory-db";
  version = "0-unstable-2025-10-20";

  owner = "rustsec";
  repo = "advisory-db";
  rev = "2ada48518d0e12b773af966e411d5e3418951825";
  hash = "sha256-/BHC9R/M4O2AK2iLXbkeX8koDhG1uR+3koIkOfiJEv0=";

  meta = {
    description = "Repository of security advisories filed against Rust crates";
    maintainers = [ lib.maintainers.RossSmyth ];
    license = lib.licenses.cc0;
  };
}
