{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  smartmontools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapraid";
  version = "14.9";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z4ycepeh8ZKqJ9vUBhZMQImBmPAxRXMgtX/apgWXatI=";
  };

  env.VERSION = finalAttrs.version;

  # snapraid only looks for smartctl in a few fixed system paths
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace cmdline/unix.c \
      --replace-fail '"/usr/sbin/smartctl"' '"${lib.getExe' smartmontools "smartctl"}"'
  '';

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];

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
