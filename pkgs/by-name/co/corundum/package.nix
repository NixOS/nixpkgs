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

  meta = with lib; {
    description = "Tool and libraries for maintaining Ruby gems";
    homepage = "https://github.com/nyarly/corundum";
    license = licenses.mit;
    maintainers = with maintainers; [
      nyarly
      nicknovitski
    ];
    platforms = platforms.unix;
  };
}
