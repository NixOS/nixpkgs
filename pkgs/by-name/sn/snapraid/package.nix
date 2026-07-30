{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  smartmontools,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapraid";
  version = "14.7";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+h4kEvNtNEe7u0N1UWmZF3bH7em+Y2/XUyAdyDliV1g=";
  };

  env.VERSION = finalAttrs.version;

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  # SMART is only supported on Linux and requires the smartmontools package
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/snapraid \
     --prefix PATH : ${lib.makeBinPath [ smartmontools ]}
  '';

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
