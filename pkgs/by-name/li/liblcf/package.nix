{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
  pkg-config,
  expat,
  icu74,
  inih,
}:

stdenv.mkDerivation rec {
  pname = "liblcf";
  # When updating this package, you should probably also update
  # easyrpg-player and libretro.easyrpg
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
    hash = "sha256-jIk55+n8wSk3Z3FPR18SE7U3OuWwmp2zJgvSZQBB2l0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    expat
    icu74
    inih
  ];

  enableParallelBuilding = true;
  enableParallelChecking = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library to handle RPG Maker 2000/2003 and EasyRPG projects";
    homepage = "https://github.com/EasyRPG/liblcf";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
