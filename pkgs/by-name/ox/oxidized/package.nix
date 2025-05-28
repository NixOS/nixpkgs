{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp rec {
  pname = "oxidized";
  gemdir = ./.;

  inherit ruby;

  exes = [
    "oxidized"
    "oxs"
  ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = with lib; {
    description = "Network device configuration backup tool. It's a RANCID replacement";
    homepage = "https://github.com/ytti/oxidized";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    teams = [ teams.wdz ];
    platforms = platforms.linux;
  };
}
