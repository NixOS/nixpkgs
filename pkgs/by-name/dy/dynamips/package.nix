{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  libelf,
  libpcap,
  nix-update-script,
  pkg-config,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dynamips";
  version = "0.2.25";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "dynamips";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ms7MtMeGbfPIzhfSgSj7KkTaFhr+fuLz1cOKFHrjchQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libelf
    libpcap
  ];

  cmakeFlags = [
    (lib.cmakeFeature "DYNAMIPS_CODE" "stable")
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cisco router emulator";
    longDescription = ''
      Dynamips is an emulator computer program that was written to emulate Cisco
      routers.
    '';
    homepage = "https://github.com/GNS3/dynamips";
    changelog = "https://github.com/GNS3/dynamips/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "dynamips";
    maintainers = with lib.maintainers; [
      anthonyroussel
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
