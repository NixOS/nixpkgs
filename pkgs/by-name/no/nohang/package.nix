{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  python3,
  sudo,
  libnotify,
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
    substituteInPlace src/* --replace 'notify-send' '${libnotify}/bin/notify-send' --replace 'sudo' '${sudo}/bin/sudo'
  '';

  buildInputs = [ python3 ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    make \
    DESTDIR="$out" \
    PREFIX="/" \
    SBINDIR="/sbin" \
    SYSCONFDIR="/etc" \
    SYSTEMDUNITDIR="/lib/systemd/system" \
    base

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) nohang;
  };

  meta = {
    homepage = "https://github.com/hakavlad/nohang";
    description = "Sophisticated low memory handler for Linux";
    license = with lib.licenses; [ mit ];
    mainProgram = "nohang";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Dev380 ];
  };
})
