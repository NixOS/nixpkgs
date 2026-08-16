{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.8";
  pname = "nqptp";

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = "nqptp";
    tag = finalAttrs.version;
    hash = "sha256-f8k1MKNVMqt8Nym1+CWLC5bAKUkmPaBZYTer+EoPAgk=";
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
