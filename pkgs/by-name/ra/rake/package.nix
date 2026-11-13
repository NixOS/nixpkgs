{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "rake";
  gemdir = ./.;
  exes = [ "rake" ];

  passthru.updateScript = bundlerUpdateScript "rake";

  meta = {
    description = "Software task management and build automation tool";
    homepage = "https://github.com/ruby/rake";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [
      nicknovitski
    ];
    platforms = lib.platforms.unix;
    mainProgram = "rake";
  };
}
