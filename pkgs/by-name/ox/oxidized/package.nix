{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
  defaultGemConfig,
  nixosTests,
}:

bundlerApp {
  pname = "oxidized";
  gemdir = ./.;

  inherit ruby;

  exes = [
    "oxidized"
    "oxs"
  ];

  gemConfig = defaultGemConfig;

  passthru = {
    tests = nixosTests.oxidized;
    updateScript = bundlerUpdateScript "oxidized";
  };

  meta = {
    description = "Network device configuration backup tool. It's a RANCID replacement";
    homepage = "https://github.com/ytti/oxidized";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nicknovitski
      liberodark
    ];
    teams = with lib.teams; [ wdz ];
    platforms = lib.platforms.linux;
  };
}
