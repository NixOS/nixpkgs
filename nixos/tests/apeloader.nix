import ./make-test-python.nix ({ pkgs, ... }: {
  name = "apeloader";
  meta = with pkgs.lib; {
    maintainers = with maintainers; [ lourkeur ];
  };

  nodes.machine = {
    programs.apeloader.enable = true;
  };

  testScript = ''
    machine.succeed("""
      # strace does `exec` directly with no support for scripts
      # hence it fails when apeloader is not enabled.
      strace ${pkgs.cosmopolitan.dist}/build/bootstrap/echo.com Hello world!
    """)
  '';
})
