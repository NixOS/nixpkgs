{ lib, ... }:
let
  inherit (builtins)
    storeDir
    ;
  inherit (lib)
    types
    mkOption
    ;
in
{
  options = {
    pathInStore = mkOption { type = types.lazyAttrsOf types.pathInStore; };
    ipv4 = mkOption { type = types.lazyAttrsOf types.address.ipv4; };
    ipv6 = mkOption { type = types.lazyAttrsOf types.address.ipv6; };
  };
  config = {
    pathInStore.ok1 = "${storeDir}/0lz9p8xhf89kb1c1kk6jxrzskaiygnlh-bash-5.2-p15.drv";
    pathInStore.ok2 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15";
    pathInStore.ok3 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15/bin/bash";
    pathInStore.bad1 = "";
    pathInStore.bad2 = "${storeDir}";
    pathInStore.bad3 = "${storeDir}/";
    pathInStore.bad4 = "${storeDir}/.links"; # technically true, but not reasonable
    pathInStore.bad5 = "/foo/bar";

    # Standard IPv4 addresses
    ipv4.ok1 = "1.2.3.4";
    ipv4.ok2 = "0.0.0.0";
    ipv4.ok3 = "255.255.255.255";

    # Bad IPv4 addresses
    ipv4.bad1 = "";
    ipv4.bad2 = "1.2.3";
    ipv4.bad3 = "256.256.256.256";

    # Full address: 1:2:3:4:5:6:7:8
    ipv6.ok1 = "2001:0db8:0000:0000:0000:ff00:0042:8329";
    ipv6.ok2 = "2001:db8:0:0:1:0:0:1";

    # Leading compression: 1::, 1:2:3:4:5:6:7::
    ipv6.ok3 = "2001:db8::";
    ipv6.ok4 = "2001:db8:0:0:1:0:0::";

    # Middle compression: 1::8, 1:2:3:4:5:6::8
    ipv6.ok5 = "2001:db8::8";
    ipv6.ok6 = "2001:db8:0:0:1::8";

    # Various compression patterns
    ipv6.ok7 = "2001:db8::1:0:0:1"; # 1::7:8
    ipv6.ok8 = "::1"; # loopback
    ipv6.ok9 = "::"; # all zeros

    # IPv4-mapped/translated addresses
    ipv6.ok10 = "::ffff:192.0.2.1"; # IPv4-mapped
    ipv6.ok11 = "::192.0.2.33"; # IPv4-compatible
    ipv6.ok12 = "64:ff9b::192.0.2.33"; # Well-known prefix

    # Case variations
    ipv6.ok13 = "2001:0DB8:0000:0000:0000:FF00:0042:8329"; # All uppercase

    # Bad IPv6 addresses
    ipv6.bad1 = ""; # Empty string
    ipv6.bad2 = "gg::1"; # Invalid hex
    ipv6.bad3 = "::ffff:256.0.0.1"; # Invalid IPv4 part
    ipv6.bad4 = "2001:db8:::1"; # Triple colon
    ipv6.bad5 = "2001:db8:0:0:0:0:0:0:1"; # Too many groups
    ipv6.bad6 = "::ffff:192.0.2"; # Incomplete IPv4
    ipv6.bad7 = "2001:0db8:0000:0000:0000:gg00:0042:8329"; # Invalid hex digit
    ipv6.bad8 = "12345::"; # Group too long
    ipv6.bad9 = "1:2:3:4:5:6:7:8:9"; # Too many groups
    ipv6.bad10 = "::1::"; # Multiple compressions
  };
}
