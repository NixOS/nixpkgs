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
  version = "13.0";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IoK37ZXlMRLDPjzsLUqcfcu4asdstFJYgHc2wAg9lno=";
  };

  VERSION = finalAttrs.version;

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
