{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "metee";
  version = "6.1.0";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "metee";
    tag = finalAttrs.version;
    hash = "sha256-ybTi4pFZAkoO6FAyUOLK+ZbTQb7uwu/sqhYxo06SE9A=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "C library to access CSE/CSME/GSC firmware via a MEI interface";
    homepage = "https://github.com/intel/metee";
    license = lib.licenses.asl20;
    changelog = "https://github.com/intel/metee/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.linux;
  };
})
