{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  smartmontools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapraid";
  version = "15.0";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ftmmd8cHeggj2PLSqyJvOly/kUBFPXYaqpHwxwE/uDc=";
  };

  env.VERSION = finalAttrs.version;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];

  # SMART is only supported on Linux; smartctl is not discovered through PATH.
  configureFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--with-smartctl=${lib.getExe' smartmontools "smartctl"}"
  ];

  meta = {
    homepage = "http://www.snapraid.it/";
    downloadPage = "https://github.com/amadvance/snapraid/releases";
    changelog = "https://github.com/amadvance/snapraid/blob/v${finalAttrs.version}/HISTORY";
    description = "Backup program for disk arrays";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.unix;
    mainProgram = "snapraid";
  };
})
