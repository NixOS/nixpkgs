# This test checks charliecloud image construction and run

import ./make-test-python.nix (
  { pkgs, ... }:
  let

    dockerfile = pkgs.writeText "Dockerfile" ''
      FROM nix
      RUN mkdir /home /tmp
      RUN touch /etc/passwd /etc/group
      CMD ["true"]
    '';

  in
  {
    name = "charliecloud";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ bzizou ];
    };

    nodes = {
      host =
        { ... }:
        {
          environment.systemPackages = [ pkgs.charliecloud ];
          virtualisation.docker.enable = true;
          users.users.alice = {
            isNormalUser = true;
            extraGroups = [ "docker" ];
          };
        };
    };

    testScript = ''
      host.start()
      host.wait_for_unit("docker.service")
      host.succeed(
          'su - alice -c "docker load --input=${pkgs.dockerTools.examples.nix}"'
      )
      host.succeed(
          "cp ${dockerfile} /home/alice/Dockerfile"
      )
      host.succeed('su - alice -c "ch-build -t hello ."')
      host.succeed('su - alice -c "ch-builder2tar hello /var/tmp"')
      host.succeed('su - alice -c "ch-tar2dir /var/tmp/hello.tar.gz /var/tmp"')
      host.succeed('su - alice -c "ch-run /var/tmp/hello -- echo Running_From_Container_OK"')
    '';
  }
)
