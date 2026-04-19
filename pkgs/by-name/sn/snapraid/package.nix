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
  version = "14.3";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ULE+CtIcsmISK3qwbTGg2xGBHvJKkZjCeH+/0Et1b9M=";
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
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.unix;
    mainProgram = "snapraid";
  };
})
