{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  nixosTests,
}:

bundlerApp {
  pname = "gemstash";
  gemdir = ./.;
  exes = [ "gemstash" ];

  passthru = {
    updateScript = bundlerUpdateScript "gemstash";
    tests = { inherit (nixosTests) gemstash; };
  };

  meta = {
    description = "Cache for RubyGems.org and a private gem server";
    homepage = "https://github.com/rubygems/gemstash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      viraptor
    ];
  };
}
