import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let
    port = 5000;
    scanPath = "/var/lib/legit";
  in
  {
    name = "legit-web";
    meta.maintainers = [ lib.maintainers.ratsclub ];

    nodes = {
      server =
        { config, pkgs, ... }:
        {
          services.legit = {
            enable = true;
            settings = {
              server.port = 5000;
              repo = {
                inherit scanPath;
              };
            };
          };

          environment.systemPackages = [ pkgs.git ];
        };
    };

    testScript =
      { nodes, ... }:
      let
        strPort = builtins.toString port;
      in
      ''
        start_all()

        server.wait_for_unit("network.target")
        server.wait_for_unit("legit.service")

        server.wait_until_succeeds(
            "curl -f http://localhost:${strPort}"
        )

        server.succeed("${pkgs.writeShellScript "setup-legit-test-repo" ''
          set -e
          git init --bare -b master ${scanPath}/some-repo
          git init -b master reference
          cd reference
          git remote add origin ${scanPath}/some-repo
          date > date.txt
          git add date.txt
          git -c user.name=test -c user.email=test@localhost commit -m 'add date'
          git push -u origin master
        ''}")

        server.wait_until_succeeds(
            "curl -f http://localhost:${strPort}/some-repo"
        )
      '';
  }
)
