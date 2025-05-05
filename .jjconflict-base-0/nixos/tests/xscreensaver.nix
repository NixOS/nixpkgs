{ lib, ... }:
{
  name = "pass-secret-service";
  meta.maintainers = with lib.maintainers; [
    vancluever
  ];

  node.pkgsReadOnly = false;

  nodes = {
    ok =
      { nodes, pkgs, ... }:
      {
        imports = [
          ./common/x11.nix
          ./common/user-account.nix
        ];
        test-support.displayManager.auto.user = "alice";
        services.xscreensaver.enable = true;
      };

    empty_wrapperPrefix =
      { nodes, pkgs, ... }:
      {
        imports = [
          ./common/x11.nix
          ./common/user-account.nix
        ];
        test-support.displayManager.auto.user = "alice";
        services.xscreensaver.enable = true;
        nixpkgs.overlays = [
          (self: super: {
            xscreensaver = super.xscreensaver.override {
              wrapperPrefix = "";
            };
          })
        ];
      };

    bad_wrapperPrefix =
      { nodes, pkgs, ... }:
      {
        imports = [
          ./common/x11.nix
          ./common/user-account.nix
        ];
        test-support.displayManager.auto.user = "alice";
        services.xscreensaver.enable = true;
        nixpkgs.overlays = [
          (self: super: {
            xscreensaver = super.xscreensaver.override {
              wrapperPrefix = "/a/bad/path";
            };
          })
        ];
      };
  };

  testScript = ''
    ok.wait_for_x()
    ok.wait_for_unit("xscreensaver", "alice")
    _, output_ok = ok.systemctl("status xscreensaver", "alice")
    assert 'To prevent the kernel from randomly unlocking' not in output_ok
    assert 'your screen via the out-of-memory killer' not in output_ok
    assert '"xscreensaver-auth" must be setuid root' not in output_ok

    empty_wrapperPrefix.wait_for_x()
    empty_wrapperPrefix.wait_for_unit("xscreensaver", "alice")
    _, output_empty_wrapperPrefix = empty_wrapperPrefix.systemctl("status xscreensaver", "alice")
    assert 'To prevent the kernel from randomly unlocking' in output_empty_wrapperPrefix
    assert 'your screen via the out-of-memory killer' in output_empty_wrapperPrefix
    assert '"xscreensaver-auth" must be setuid root' in output_empty_wrapperPrefix

    bad_wrapperPrefix.wait_for_x()
    bad_wrapperPrefix.wait_for_unit("xscreensaver", "alice")
    _, output_bad_wrapperPrefix = bad_wrapperPrefix.systemctl("status xscreensaver", "alice")
    assert 'To prevent the kernel from randomly unlocking' in output_bad_wrapperPrefix
    assert 'your screen via the out-of-memory killer' in output_bad_wrapperPrefix
    assert '"xscreensaver-auth" must be setuid root' in output_bad_wrapperPrefix
  '';
}
