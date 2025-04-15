{ lib, compression, ... }:
{
  name = "binary-cache-" + compression;
  meta.maintainers = with lib.maintainers; [ thomasjm ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];
      environment.systemPackages = with pkgs; [
        openssl
        python3
      ];

      # We encrypt the binary cache before putting it on the machine so Nix
      # doesn't bring any references along.
      environment.etc."binary-cache.tar.gz.encrypted".source =
        with pkgs;
        runCommand "binary-cache.tar.gz.encrypted"
          {
            allowReferences = [ ];
            nativeBuildInputs = [ openssl ];
          }
          ''
            tar -czf tmp.tar.gz -C "${
              mkBinaryCache {
                rootPaths = [ hello ];
                inherit compression;
              }
            }" .
            openssl enc -aes-256-cbc -salt -in tmp.tar.gz -out $out -k mysecretpassword
          '';

      nix.extraOptions = ''
        experimental-features = nix-command
      '';
    };

  testScript = ''
    # Decrypt the cache into /tmp/binary-cache.tar.gz
    machine.succeed("openssl enc -d -aes-256-cbc -in /etc/binary-cache.tar.gz.encrypted -out /tmp/binary-cache.tar.gz -k mysecretpassword")

    # Untar the cache into /tmp/cache
    machine.succeed("mkdir /tmp/cache")
    machine.succeed("tar -C /tmp/cache -xf /tmp/binary-cache.tar.gz")

    # Sanity test of cache structure
    status, stdout = machine.execute("ls /tmp/cache")
    cache_files = stdout.split()
    assert ("nix-cache-info" in cache_files)
    assert ("nar" in cache_files)

    # Nix store ping should work
    machine.succeed("nix store ping --store file:///tmp/cache")

    # Cache should contain a .narinfo referring to "hello"
    grepLogs = machine.succeed("grep -l 'StorePath: /nix/store/[[:alnum:]]*-hello-.*' /tmp/cache/*.narinfo")

    # Get the store path referenced by the .narinfo
    narInfoFile = grepLogs.strip()
    narInfoContents = machine.succeed("cat " + narInfoFile)
    import re
    match = re.match(r"^StorePath: (/nix/store/[a-z0-9]*-hello-.*)$", narInfoContents, re.MULTILINE)
    if not match: raise Exception("Couldn't find hello store path in cache")
    storePath = match[1]

    # Make sure the store path doesn't exist yet
    machine.succeed("[ ! -d %s ] || exit 1" % storePath)

    # Should be able to build hello using the cache
    logs = machine.succeed("nix-build -A hello '<nixpkgs>' --option require-sigs false --option trusted-substituters file:///tmp/cache --option substituters file:///tmp/cache 2>&1")
    logLines = logs.split("\n")
    if not "this path will be fetched" in logLines[0]: raise Exception("Unexpected first log line")
    def shouldBe(got, desired):
      if got != desired: raise Exception("Expected '%s' but got '%s'" % (desired, got))
    shouldBe(logLines[1], "  " + storePath)
    shouldBe(logLines[2], "copying path '%s' from 'file:///tmp/cache'..." % storePath)
    shouldBe(logLines[3], storePath)

    # Store path should exist in the store now
    machine.succeed("[ -d %s ] || exit 1" % storePath)
  '';
}
