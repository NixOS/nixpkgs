{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "redis-dump";
  gemdir = ./.;
  exes = [
    "redis-dump"
    "redis-load"
  ];

  passthru.updateScript = bundlerUpdateScript "redis-dump";

  meta = {
    description = "Backup and restore your Redis data to and from JSON";
    homepage = "https://delanotes.com/redis-dump/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
