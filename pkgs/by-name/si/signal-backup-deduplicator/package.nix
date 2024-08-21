{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  cryptopp,
  protobuf,
}:

stdenv.mkDerivation {
  pname = "signal-backup-deduplicator";
  version = "0-unstable-2024-05-24";

  src = fetchFromGitLab {
    owner = "gerum";
    repo = "signal-backup-deduplicator";
    rev = "6c09f14b16ff47c2ed0914c68102e45c93ebbfa6";
    hash = "sha256-JR2Qu4EtTMObM/BvxQS5WwGFqWj9g0bqOpKt4y5UNaM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    protobuf
    cryptopp
  ];

  meta = {
    description = "Generate chunked backups for Signal messages";
    homepage = "https://gitlab.com/gerum/signal-backup-deduplicator";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "signal_backup_deduplicate";
    platforms = lib.platforms.all;
    # ld: symbol(s) not found for architecture ...
    broken = stdenv.isDarwin;
  };
}
