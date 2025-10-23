{
  lib,
  stdenv,
  fetchFromGitHub,
  nixVersions,
  nixComponents ? nixVersions.nixComponents_2_30,
  cmake,
  pkg-config,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "nix-plugins";
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    hash = "sha256-yofHs1IyAkyMqrWlLkmnX+CmH+qsvlhKN1YZM4nRf1M=";
  };

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
