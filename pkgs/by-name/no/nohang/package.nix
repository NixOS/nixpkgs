{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  python3,
  sudo,
  libnotify,
  coreutils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nohang";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hakavlad";
    repo = "nohang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gCGjQoSxY/MprrcpdFrJ4VrsNyruqsUSPrHoy+R07Io=";
  };

  postPatch = ''
    patchShebangs src
    substituteInPlace src/nohang \
      --replace-fail 'notify-send' '${lib.getExe libnotify}' \
      --replace-fail 'sudo' '${lib.getExe sudo}' \
      --replace-fail "'env'" "'${lib.getExe' coreutils "env"}'"
  '';

  buildInputs = [ python3 ];

  dontBuild = true;

  installTargets = [ "base" ];
  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX=/"
    "SBINDIR=/sbin"
    "SYSCONFDIR=/etc"
    "SYSTEMDUNITDIR=/lib/systemd/system"
  ];

  passthru.tests = {
    inherit (nixosTests) nohang;
  };

  meta = {
    homepage = "https://github.com/hakavlad/nohang";
    description = "Sophisticated low memory handler for Linux";
    license = with lib.licenses; [ mit ];
    mainProgram = "nohang";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Dev380 ];
  };
})
