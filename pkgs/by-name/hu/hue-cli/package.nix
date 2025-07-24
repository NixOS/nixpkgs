{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "hue-cli";
  gemdir = ./.;
  exes = [ "hue" ];

  passthru.updateScript = bundlerUpdateScript "hue-cli";

  meta = {
    description = "Command line interface for controlling Philips Hue system's lights and bridge";
    homepage = "https://github.com/birkirb/hue-cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      manveru
      nicknovitski
    ];
    mainProgram = "hue";
  };
}
