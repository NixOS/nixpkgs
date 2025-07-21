# Test whether `houndd` indexes nixpkgs
{ pkgs, ... }:
{
  name = "hound";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ grahamc ];
  };
  nodes.machine =
    { pkgs, ... }:
    {
      services.hound = {
        enable = true;
        settings = {
          "max-concurrent-indexers" = 1;
          "dbpath" = "/var/lib/hound/data";
          "repos" = {
            "nix" = {
              "url" = "file:///var/lib/hound/my-git";
            };
          };
        };
      };

      systemd.services.houndseed = {
        description = "seed hound with a git repo";
        requiredBy = [ "hound.service" ];
        before = [ "hound.service" ];

        serviceConfig = {
          User = "hound";
          Group = "hound";
          WorkingDirectory = "/var/lib/hound";
        };
        path = [ pkgs.git ];
        script = ''
          git config --global user.email "you@example.com"
          git config --global user.name "Your Name"
          git init my-git --bare
          git init my-git-clone
          cd my-git-clone
          echo 'hi nix!' > hello
          git add hello
          git commit -m "hello there :)"
          git remote add origin /var/lib/hound/my-git
          git push origin master
        '';
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("network.target")
    machine.wait_for_unit("hound.service")
    machine.wait_for_open_port(6080)
    machine.wait_until_succeeds(
        "curl -f http://127.0.0.1:6080/api/v1/search\?stats\=fosho\&repos\=\*\&rng=%3A20\&q\=hi\&files\=\&i=nope | grep 'Filename' | grep 'hello'"
    )
  '';
}
