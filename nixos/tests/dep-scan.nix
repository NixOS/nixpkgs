{
  lib,
  pkgs,
  ...
}:

{
  name = "owasp dep-scan test";

  meta.maintainers = with lib; [
    maintainers.ethancedwards8
    teams.ngi
  ];

  nodes.machine = {
    environment.systemPackages = with pkgs; [
      dep-scan
      jq
    ];

    # code repo to scan for vulnerabilites, could be anything
    # I just happened to pick the source of the package
    environment.etc."dep-scan-source".source = pkgs.fetchFromGitHub {
      owner = "owasp-dep-scan";
      repo = "dep-scan";
      tag = "v6.0.0b3";
      hash = "sha256-GdrFsECcBZ2J47ojM33flqOtrY3avchGpsZk6pt8Aks=";
    };

    # we need to download the database before the vm starts, otherwise
    # the program will try to download them at runtime.
    # https://github.com/owasp-dep-scan/dep-scan/issues/443
    environment.etc."vdb/data.index.vdb6".source = pkgs.fetchurl {
      url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/72377024f9742c6e700a113fc7059b18f738081c/app-2y/data.index.vdb6";
      hash = "sha256-/9RIL6KVwmUmcKteOhWlnzjtZzGUbmRzua5o4Z8Mu9I=";
    };
    environment.etc."vdb/data.vdb6".source = pkgs.fetchurl {
      url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/72377024f9742c6e700a113fc7059b18f738081c/app-2y/data.vdb6";
      hash = "sha256-6gCftnjal9ZMXV+25fVANdJRuI/CN083OOnc8yA5TTw=";
    };
    environment.etc."vdb/vdb.meta".source = pkgs.fetchurl {
      url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/72377024f9742c6e700a113fc7059b18f738081c/app-2y/vdb.meta";
      hash = "sha256-i0oI3ODrmm8PF9UGJ9gy9QzQ0SKjLo9DdqYX/kqoHak=";
    };
    environment.variables = {
      VDB_HOME = "/tmp/vdb";
      # the cache will try to auto refresh if the age is met (requires internet access)
      VDB_AGE_HOURS = 999999;
    };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      # vdb needs to be copied to tmp as it needs to write to dir
      # and etc is RO
      machine.succeed('cp -rL /etc/vdb /tmp/vdb')
      machine.succeed('depscan --src /etc/dep-scan-source --reports-dir /tmp/reports')
      machine.succeed('jq . /tmp/reports/*.json')
    '';
}
