{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  smartmontools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapraid";
  version = "15.2";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KCidpX5MWjHW4i9Lhtyvglg0uVJktcL6kWJyMPXnF7U=";
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
