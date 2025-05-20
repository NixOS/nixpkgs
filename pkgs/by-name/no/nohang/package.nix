{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  sudo,
  libnotify,
  coreutils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nohang";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hakavlad";
    repo = "nohang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aRiBGnJHdtQ5euvJ4DSuCZO5i5OJVRiCesaatrIARmg=";
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

  meta = {
    homepage = "https://github.com/hakavlad/nohang";
    description = "Sophisticated low memory handler for Linux";
    license = with lib.licenses; [ mit ];
    mainProgram = "nohang";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Dev380 ];
  };
})
