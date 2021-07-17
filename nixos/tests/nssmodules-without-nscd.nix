# Ensure that NSS modules are accessible by glibc client binaries when
# nscd is disabled

import ./make-test-python.nix ({ lib, ... } : {
  name = "nssmodules-without-nscd";

  meta = with lib.maintainers; {
    maintainers = [ earvstedt flokli ];
  };

  nodes.node = {
    services.nscd.enable = false;
  };

  # Test dynamic user resolution via `libnss_systemd.so` which is only available
  # through `system.nssModules`
  testScript = ''
    node.succeed("systemd-run --property=DynamicUser=yes --property=User=testuser sleep infinity")
    node.succeed("getent passwd testuser")
  '';
})
