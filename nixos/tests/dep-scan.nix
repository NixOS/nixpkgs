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
      url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/40609f230dd7c83178e054e0219c367b49a2c920/app-2y/data.index.vdb6";
      hash = "sha256-UyE0xiLT0T4ygBdEvDi4VQW/vxwalN6YV9EJ9RoLYy4=";
    };
    environment.etc."vdb/data.vdb6".source = pkgs.fetchurl {
      url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/40609f230dd7c83178e054e0219c367b49a2c920/app-2y/data.vdb6";
      hash = "sha256-k5QIowFD8H/hwaRz1p8RXlFEIrKjnFUtxtZTfD67B+U=";
    };
    environment.etc."vdb/vdb.meta".source = pkgs.fetchurl {
      url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/40609f230dd7c83178e054e0219c367b49a2c920/app-2y/vdb.meta";
      hash = "sha256-eQB0dHlNw31sKsRcVUByhIfuIN35+m3VAcBHIfusNPY=";
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
