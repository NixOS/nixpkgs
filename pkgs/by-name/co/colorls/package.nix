{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "colorls";

  gemdir = ./.;
  exes = [ "colorls" ];

  passthru.updateScript = bundlerUpdateScript "colorls";

  meta = {
    description = "Prettified LS";
    homepage = "https://github.com/athityakumar/colorls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lukebfox
      nicknovitski
      cbley
    ];
    mainProgram = "colorls";
  };
}
