import ./make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "binary-cache";
  meta.maintainers = with lib.maintainers; [ thomasjm ];

  nodes.machine =
    { pkgs, ... }: {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];
      environment.systemPackages = [ pkgs.python3 ];
      system.extraDependencies = [ pkgs.hello.inputDerivation ];
      nix.extraOptions = ''
        experimental-features = nix-command
      '';
    };

  testScript = ''
    # Build the cache, then remove it from the store
    cachePath = machine.succeed("nix-build --no-out-link -E 'with import <nixpkgs> {}; mkBinaryCache { rootPaths = [hello]; }'").strip()
    machine.succeed("cp -r %s/. /tmp/cache" % cachePath)
    machine.succeed("nix-store --delete " + cachePath)

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

    # Delete the store path
    machine.succeed("nix-store --delete " + storePath)
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
})
