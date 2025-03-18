import ./make-test-python.nix ({ pkgs, ...} : {
  name = "clarissa";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ evils ];
  };

  nodes.censusTaker = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.clar ];
    services.clarissa = {
      enable = true;
      extraOptions = "-vvv";
    };
    # required to get the hostname etc. of the other node
    # unclear why that's not needed on the other node
    networking = {
      useDHCP = false;
      useNetworkd = true;
    };
  };

  nodes.hannibal = { pkgs, ... }: { environment.systemPackages = [ pkgs.iputils ]; };

  testScript =
    ''
      start_all()
      censusTaker.wait_for_unit("multi-user.target")
      hannibal.wait_for_unit("multi-user.target")

      # ensure censusTaker first sees a packet from hannibal
      hannibal.wait_until_succeeds("ping -4c 1 censusTaker")

      # check if censusTaker saw hannibal
      # TODO: check for the actual MAC and IP address
      censusTaker.succeed("clar show | tee /dev/stderr | grep -q 'hannibal'")

      hannibal.shutdown()
      censusTaker.shutdown()
    '';
})

