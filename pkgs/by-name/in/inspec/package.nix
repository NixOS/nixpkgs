{
  lib,
  ruby_3_4, # fix "Source locally installed gems is ignoring ... because it is missing extensions"
  bundlerApp,
  bundlerUpdateScript,
  inspec,
  testers,
}:

bundlerApp {
  pname = "inspec";
  gemdir = ./.;

  ruby = ruby_3_4;

  exes = [ "inspec" ];

  passthru = {
    updateScript = bundlerUpdateScript "inspec";
    tests.version = testers.testVersion {
      package = inspec;
      command = "inspec version";
      inherit ((import ./gemset.nix).inspec) version;
    };
  };

  meta = {
    description = "Open-source testing framework for infrastructure with a human- and machine-readable language for specifying compliance, security and policy requirements";
    homepage = "https://inspec.io/";
    license = lib.licenses.unfree; # rubygems distribution is unfree, see https://github.com/inspec/inspec/blob/main/Chef-EULA
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    mainProgram = "inspec";
  };
}
