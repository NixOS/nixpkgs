{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdapsd";
  version = "20250908";

  src = fetchFromGitHub {
    owner = "linux-thinkpad";
    repo = "hdapsd";
    tag = finalAttrs.version;
    hash = "sha256-/62E10fmv8idQFLVLgKkDomhBQk+DOc9167lkVBiRns=";
  };

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];

  doInstallCheck = true;

  postInstall = builtins.readFile ./postInstall.sh;

  meta = {
    description = "Hard Drive Active Protection System Daemon";
    mainProgram = "hdapsd";
    homepage = "http://hdaps.sf.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ starryreverie ];
  };
})
