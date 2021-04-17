import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "qemu-private-store";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ chkno ];
  };

  nodes = {
    shared = _: { };
    private = _: {
      virtualisation.shareNixStore = false;
      virtualisation.shareExchangeDir = false;
    };
  };

  testScript = ''
    start_all()
    shared.wait_for_unit("multi-user.target")
    private.wait_for_unit("multi-user.target")

    shared.succeed("[[ $(mount | grep -c virt) -gt 0 ]]")
    private.succeed("[[ $(mount | grep -c virt) -eq 0 ]]")
  '';
})
