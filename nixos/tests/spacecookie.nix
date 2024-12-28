let
  gopherRoot = "/tmp/gopher";
  gopherHost = "gopherd";
  gopherClient = "client";
  fileContent = "Hello Gopher!\n";
  fileName = "file.txt";
in
import ./make-test-python.nix (
  { ... }:
  {
    name = "spacecookie";
    nodes = {
      ${gopherHost} = {
        systemd.services.spacecookie = {
          preStart = ''
            mkdir -p ${gopherRoot}/directory
            printf "%s" "${fileContent}" > ${gopherRoot}/${fileName}
          '';
        };

        services.spacecookie = {
          enable = true;
          openFirewall = true;
          settings = {
            root = gopherRoot;
            hostname = gopherHost;
          };
        };
      };

      ${gopherClient} = { };
    };

    testScript = ''
      start_all()

      # with daemon type notify, the unit being started
      # should also mean the port is open
      ${gopherHost}.wait_for_unit("spacecookie.service")
      ${gopherClient}.wait_for_unit("network.target")

      fileResponse = ${gopherClient}.succeed("curl -f -s gopher://${gopherHost}/0/${fileName}")

      # the file response should return our created file exactly
      if not (fileResponse == "${builtins.replaceStrings [ "\n" ] [ "\\n" ] fileContent}"):
          raise Exception("Unexpected file response")

      # sanity check on the directory listing: we serve a directory and a file
      # via gopher, so the directory listing should have exactly two entries,
      # one with gopher file type 0 (file) and one with file type 1 (directory).
      dirResponse = ${gopherClient}.succeed("curl -f -s gopher://${gopherHost}")
      dirEntries = [l[0] for l in dirResponse.split("\n") if len(l) > 0]
      dirEntries.sort()

      if not (["0", "1"] == dirEntries):
          raise Exception("Unexpected directory response")
    '';
  }
)
