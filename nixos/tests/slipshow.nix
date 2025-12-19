{
  lib,
  pkgs,
  ...
}:
{
  name = "slipshow presentation test";

  meta.maintainers = with lib.maintainers; [ ethancedwards8 ];

  nodes.machine = {
    environment.systemPackages = with pkgs; [ slipshow ];

    environment.etc."slipshow".source = pkgs.fetchFromGitHub {
      owner = "meithecatte";
      repo = "bbslides";
      rev = "ce1c08cafa71ae36dda8cc581956548b8386ae16";
      hash = "sha256-sOydmvtDeMhNejDkwlsXdrbwtqN6lcNnzTnGzBVRFxA=";
    };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      # it may take around a minute to compile the file and serve it
      machine.succeed("slipshow serve -p 6000 /etc/slipshow/bbslides.md &>/dev/null &")

      machine.wait_for_open_port(6000)
      machine.succeed("curl -i 0.0.0.0:6000")
    '';
}
