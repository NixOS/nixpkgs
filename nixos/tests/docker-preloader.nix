import ./make-test-python.nix ({ pkgs, ...} : {
  name = "docker-preloader";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lewo ];
  };

  nodes = {
    docker =
      { pkgs, ... }:
        {
          virtualisation.docker.enable = true;
          virtualisation.dockerPreloader.images = [ pkgs.dockerTools.examples.nix pkgs.dockerTools.examples.bash ];

          services.openssh.enable = true;
          services.openssh.permitRootLogin = "yes";
          services.openssh.extraConfig = "PermitEmptyPasswords yes";
          users.extraUsers.root.password = "";
        };
  };
  testScript = ''
    start_all()

    docker.wait_for_unit("sockets.target")
    docker.succeed("docker run nix nix-store --version")
    docker.succeed("docker run bash bash --version")
  '';
})
