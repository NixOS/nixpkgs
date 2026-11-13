{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "corundum";
  gemdir = ./.;
  exes = [ "corundum-skel" ];

  # Last release was in 2019 and it requires bundler ~> 1.10, so bundlerUpdateScript fails
  passthru.updateScript = null;

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
