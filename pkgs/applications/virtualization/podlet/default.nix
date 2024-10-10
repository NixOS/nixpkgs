{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "podlet";
  version = "v0.3.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    hash = "sha256-STkYCaXBoQSmFKpMdsKzqFGXHh9s0jeGi5K2itj8jmc=";
  };

  cargoHash = "sha256-0V2DTpEjDgo+NQHw1d01g24zi6u1PxS4jB8LPfC6MP0=";

  meta = {
    description = "Podlet generates Podman Quadlet files from a Podman command, compose file, or existing object.";
    homepage = "https://github.com/containers/podlet";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
