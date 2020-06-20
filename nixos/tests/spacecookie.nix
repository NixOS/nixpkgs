let
  gopherRoot  = "/tmp/gopher";
  gopherHost  = "gopherd";
  fileContent = "Hello Gopher!";
  fileName    = "file.txt";
in
  import ./make-test-python.nix ({...}: {
    name = "spacecookie";
    nodes = {
      ${gopherHost} = {
        networking.firewall.allowedTCPPorts = [ 70 ];
        systemd.services.spacecookie = {
          preStart = ''
            mkdir -p ${gopherRoot}/directory
            echo "${fileContent}" > ${gopherRoot}/${fileName}
          '';
        };

        services.spacecookie = {
          enable = true;
          root = gopherRoot;
          hostname = gopherHost;
        };
      };

      client = {};
    };

    testScript = ''
      start_all()
      ${gopherHost}.wait_for_open_port(70)
      ${gopherHost}.wait_for_unit("spacecookie.service")
      client.wait_for_unit("network.target")

      fileResponse = client.succeed("curl -s gopher://${gopherHost}//${fileName}")

      # the file response should return our created file exactly
      if not (fileResponse == "${fileContent}\n"):
          raise Exception("Unexpected file response")

      # sanity check on the directory listing: we serve a directory and a file
      # via gopher, so the directory listing should have exactly two entries,
      # one with gopher file type 0 (file) and one with file type 1 (directory).
      dirResponse = client.succeed("curl -s gopher://${gopherHost}")
      dirEntries = [l[0] for l in dirResponse.split("\n") if len(l) > 0]
      dirEntries.sort()

      if not (["0", "1"] == dirEntries):
          raise Exception("Unexpected directory response")
    '';
  })
