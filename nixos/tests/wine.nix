import ./make-test-python.nix ({ pkgs, ... }: {
  name = "wine";
  meta = with pkgs.lib.maintainers; { maintainers = [ chkno ]; };

  machine = { pkgs, ... }: { environment.systemPackages = [ pkgs.wine ]; };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    greeting = machine.succeed(
        'wine ${pkgs.pkgsCross.mingw32.hello}/bin/hello.exe'
    )
    assert 'Hello, world!' in greeting
  '';
})
