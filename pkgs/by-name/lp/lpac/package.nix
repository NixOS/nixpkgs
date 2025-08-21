{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  pcsclite,
  curl,
  withDrivers ? true,
  withLibeuicc ? true,
  nix-update-script,
}:

let
  inherit (lib) optional;
in
stdenv.mkDerivation (finalAttrs: {

  pname = "lpac";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "estkme-group";
    repo = "lpac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dxoYuX3dNj4piXQBqU4w1ICeyOGid35c+6ZITQiN6wA=";
  };

  env.LPAC_VERSION = finalAttrs.version;

  patches = [ ./lpac-version.patch ];

  cmakeFlags = [
    (lib.cmakeBool "LPAC_DYNAMIC_DRIVERS" withDrivers)
    (lib.cmakeBool "LPAC_DYNAMIC_LIBEUICC" withLibeuicc)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    pcsclite
  ];

  passthru = {
    updateScript = nix-update-script { attrPath = finalAttrs.pname; };
  };

  meta = {
    description = "C-based eUICC LPA";
    homepage = "https://github.com/estkme-group/lpac";
    mainProgram = "lpac";
    changelog = "https://github.com/estkme-group/lpac/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.agpl3Plus ] ++ optional withLibeuicc lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    platforms = lib.platforms.all;
  };
})
