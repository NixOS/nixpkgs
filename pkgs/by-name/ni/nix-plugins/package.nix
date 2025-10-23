{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nixVersions,
  nixComponents ? nixVersions.nixComponents_2_30,
  cmake,
  pkg-config,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "nix-plugins";
  version = "16.0.0-patched";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    hash = "sha256-yofHs1IyAkyMqrWlLkmnX+CmH+qsvlhKN1YZM4nRf1M=";
  };

  patches = [
    # https://github.com/shlevy/nix-plugins/pull/23
    (fetchpatch2 {
      name = "fix-build-nix-2.32.1.patch";
      url = "https://github.com/shlevy/nix-plugins/commit/e0115e16b3835e99b7aa4ced15746159e79a1be6.patch";
      hash = "sha256-E6QISZ8k8xKNzWqIeaOzxJN0DQvkMSQul9MJBdxwymk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    nixComponents.nix-expr
    nixComponents.nix-main
    nixComponents.nix-store
    nixComponents.nix-cmd
    boost
  ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = "https://github.com/shlevy/nix-plugins";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
