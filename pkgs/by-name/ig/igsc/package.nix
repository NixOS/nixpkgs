{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
  cmake,
  metee,
  udev,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "igsc";
  version = "0.9.6";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    tag = "V${finalAttrs.version}";
    hash = "sha256-ecjcDYirbJC2s48+SOwFuJAJQ6eaabTrmgTjgb+dXrA=";
  };

  buildInputs = [
    metee
    udev
  ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DMETEE_LIB_PATH=${metee}/lib"
    "-DMETEE_HEADER_PATH=${metee}/include"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "igsc";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Intel graphics system controller firmware update library";
    homepage = "https://github.com/intel/igsc";
    license = lib.licenses.asl20;
    changelog = "https://github.com/intel/igsc/releases/tag/V${finalAttrs.version}";
    platforms = lib.platforms.linux;
  };
})
