# GNS3 Server {#module-services-atalkd}

atalkd (AppleTalk daemon) is a component inside of the suite of software provided by Netatalk. It allows for the creation of AppleTalk networks, typically speaking over a Linux ethernet network interface, that can still be seen by classic macintosh computers. Using the NixOS module, you can specify a set of network interfaces that you wish to speak AppleTalk on, and the corresponding ATALKD.CONF(5) values to go along with it.

## Basic Usage {#module-services-atlakd-basic-usage}

A minimal configuration looks like this:

```nix
{
  services.atalkd = {
    enable = true;
    interfaces.wlan0.config = "-router -phase 2 -net 1 -addr 1.48 -zone \"Default\"";
  };
}
```

