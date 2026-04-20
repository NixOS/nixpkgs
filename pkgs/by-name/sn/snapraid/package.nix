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
  version = "14.2";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IX1vvARLCJf/iK0TpE2d5cCdRWP2ou/n2gST/tp+fqs=";
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
    description = "Backup program for disk arrays";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.unix;
    mainProgram = "snapraid";
  };
})
