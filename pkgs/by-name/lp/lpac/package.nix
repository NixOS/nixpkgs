{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  pcsclite,
  curl,
  drivers ? true,
  libeuicc ? true,
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
    rev = "v${finalAttrs.version}";
    hash = "sha256-dxoYuX3dNj4piXQBqU4w1ICeyOGid35c+6ZITQiN6wA=";
  };

  env.LPAC_VERSION = finalAttrs.version;

  patches = [ ./lpac-version.patch ];

  cmakeFlags =
    optional drivers "-DLPAC_DYNAMIC_DRIVERS=on"
    ++ optional libeuicc "-DLPAC_DYNAMIC_LIBEUICC=on";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    pcsclite
  ];

  passthru = {
    updateScriptEnabled = true;
    updateScript = nix-update-script { attrPath = finalAttrs.pname; };
  };

  meta = {
    description = "C-based eUICC LPA";
    homepage = "https://github.com/estkme-group/lpac";
    mainProgram = "lpac";
    license = [ lib.licenses.agpl3Plus ] ++ optional libeuicc lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    platforms = lib.platforms.all;
  };
})
