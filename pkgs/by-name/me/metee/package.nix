{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "metee";
  version = "6.2.4";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "metee";
    tag = finalAttrs.version;
    hash = "sha256-7B4NCFl9vSCzL6IOa0J9T53XLuf/SHsZTiLMsRR4C6k=";
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
