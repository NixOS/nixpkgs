# Test whether `avahi-daemon' and `libnss-mdns' work as expected.

import ./make-test.nix {
  name = "avahi";

  nodes = {
    one =
      { config, pkgs, ... }: {
        services.avahi.enable = true;
        services.avahi.nssmdns = true;
      };

    two =
      { config, pkgs, ... }: {
        services.avahi.enable = true;
        services.avahi.nssmdns = true;
      };
  };

  testScript =
    '' startAll;

       # mDNS.
       $one->waitForUnit("network.target");
       $two->waitForUnit("network.target");

       $one->succeed("avahi-resolve-host-name one.local | tee out >&2");
       $one->succeed("test \"`cut -f1 < out`\" = one.local");
       $one->succeed("avahi-resolve-host-name two.local | tee out >&2");
       $one->succeed("test \"`cut -f1 < out`\" = two.local");

       $two->succeed("avahi-resolve-host-name one.local | tee out >&2");
       $two->succeed("test \"`cut -f1 < out`\" = one.local");
       $two->succeed("avahi-resolve-host-name two.local | tee out >&2");
       $two->succeed("test \"`cut -f1 < out`\" = two.local");

       # Basic DNS-SD.
       $one->succeed("avahi-browse -r -t _workstation._tcp | tee out >&2");
       $one->succeed("test `wc -l < out` -gt 0");
       $two->succeed("avahi-browse -r -t _workstation._tcp | tee out >&2");
       $two->succeed("test `wc -l < out` -gt 0");

       # More DNS-SD.
       $one->execute("avahi-publish -s \"This is a test\" _test._tcp 123 one=1 &");
       $one->sleep(5);
       $two->succeed("avahi-browse -r -t _test._tcp | tee out >&2");
       $two->succeed("test `wc -l < out` -gt 0");

       # NSS-mDNS.
       $one->succeed("getent hosts one.local >&2");
       $one->succeed("getent hosts two.local >&2");
       $two->succeed("getent hosts one.local >&2");
       $two->succeed("getent hosts two.local >&2");
    '';
}
