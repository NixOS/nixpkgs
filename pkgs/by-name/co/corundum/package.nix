{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "corundum";
  gemdir = ./.;
  exes = [ "corundum-skel" ];

  passthru.updateScript = bundlerUpdateScript "corundum";

  meta = {
    description = "Tool and libraries for maintaining Ruby gems";
    homepage = "https://github.com/nyarly/corundum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nyarly
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
