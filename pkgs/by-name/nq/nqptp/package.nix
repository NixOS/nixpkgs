{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.7";
  pname = "nqptp";

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = "nqptp";
    tag = finalAttrs.version;
    hash = "sha256-A87sIwn8NgfUGiCsCq/iiwcqnkfZtLbE9LrjLiWiiWc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  passthru.updateScript = gitUpdater {
    ignoredVersions = ".*(-dev|d0)";
  };

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    cp nqptp.service $out/lib/systemd/system
  '';

  meta = {
    homepage = "https://github.com/mikebrady/nqptp";
    description = "Daemon and companion application to Shairport Sync that monitors timing data from any PTP clocks";
    license = lib.licenses.gpl2Only;
    mainProgram = "nqptp";
    maintainers = with lib.maintainers; [
      jordanisaacs
      adamcstephens
    ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
