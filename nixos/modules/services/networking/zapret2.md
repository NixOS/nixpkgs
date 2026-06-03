# Zapret2 {#module-services-zapret2}

[Zapret2](https://github.com/bol-van/zapret2) is a service that enables
bypassing DPI systems using extensible Lua filters that process outgoing
network traffic.

For details on which parameters are available and their usage, consult the
[upstream documentation][1].

## Quick Start {#module-services-zapret2-quick-start}

A simple, minimal setup that includes only a single profile that applies two
Lua [instances][2] to TLS ClientHello packets can be defined as follows:

```nix
{
  services.zapret2 = {
    enable = true;
    profiles.default.parameters = [
      "--filter-tcp=443"
      "--payload=tls_client_hello"
      "--lua-desync=fake:blob=fake_default_tls:tcp_ts=-1000:repeats=1"
      "--lua-desync=fakedsplit:pos=1,midsld:tcp_ts=-1000"
    ];
  };
}
```

## Configuration {#module-services-zapret2-configuration}

The NixOS module for Zapret2 adds a small structured interface on top of the
typical plain argument list that is passed to `nfqws2`. This allows e.g.
profiles to be defined across multiple modules and merged correctly.

### Profiles {#module-services-zapret2-configuration-profiles}

Each Zapret2 profile is defined under the {option}`services.zapret2.profiles`
option. Multiple profiles can be defined at once, however it's important to
ensure that each profile can only match one category of traffic by using
`--filter-*` parameters, because otherwise a profile will match all traffic,
and since first match wins, no other profile can match it, even if it has a
more specific filter:

```nix
{
  services.zapret2.profiles = {
    http.parameters = [
      "--filter-tcp=80"
      "--payload=http_req"
      "--lua-desync=http_methodeol"
    ];
    https.parameters = [
      "--filter-tcp=443"
      "--payload=tls_client_hello"
      "--lua-desync=multisplit:pos=1,sniext+1,host+1,midsld-2,midsld,midsld+2,endhost-1"
    ];
    stun.parameters = [
      "--filter-udp=*"
      "--payload=stun,discord_ip_discovery"
      "--lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=2"
    ];
  };
}
```

Since profiles are matched on their order and first match wins, each profile
also has a {option}`services.zapret2.profiles.‹name›.priority` option. Lower
values will cause the profile to be ordered *before* others, higher values will
cause the profile to be ordered *after* others. The default priority is `1000`.
In other words, if you want to define a "fallback" profile that matches traffic
not matched by any other profile, you should set the priority to a higher value
such as `1500`.

Each profile's parameters can have the typical filters such as `--filter-tcp=*`
or `--filter-udp=*`, however for matching hostnames and IP addresses, there are
a few options to make this more convenient:

```nix
{
  services.zapret2.profiles.default = {
    hosts = {
      # Automatically keep track of which hosts need the DPI bypass and which
      # don't. This works by Zapret2 checking if the connection would otherwise
      # be matched by the profile, and if it is, it first bypasses it, however
      # it monitors the connection to see if it gets denied (for example, if a
      # TCP RST packet is received right after the TLS ClientHello is sent). If
      # this happens, it will then add it to the auto host list (that is
      # persisted on disk), so subsequent connections will succeed.
      auto.enable = true;

      # If you wish to change where the automatic hostlist file is saved, from
      # the default location of `/var/lib/zapret2/‹name›-hosts.txt`, for
      # example to share between multiple profiles:
      auto.file = "/var/lib/zapret2/hosts.txt";

      # Hardcoded list of DNS domains to include/exclude. Note that domains are
      # matched including all their subdomains, so `nixos.org` also includes
      # `cache.nixos.org` for example, and `ru` includes `gosuslugi.ru`. If you
      # don't want this behaviour, you should add `^` to the beginning of the
      # entry, e.g. `^example.com` will match `example.com` but not
      # `www.example.com`.
      include = [
        "cachix.org"
        "nixos.org"
      ];
      exclude = [ "ru" ];
    };

    ips = {
      # Like with hostnames, hardcoded list of IP addresses or subnets in CIDR
      # notation to include/exclude. Note that by default, the firewall already
      # excludes local networks (as defined by RFC 1918), so they are not
      # passed to Zapret2.
      include = [ "213.59.192.0/18" ];
      exclude = [ "173.245.48.0/20" ];
    };
  };
}
```

If either an IP/host include list is defined, or host auto mode is enabled, the
profile will enter a whitelist mode, where traffic by default won't be matched
(except the special connection tracking case of the auto mode). If an IP/host
exclude list is defined, traffic not on the exclude list is still matched by
default, unless an include list is also defined.

In addition to the options above, you may of course define `--ipset-*` or
`--hostlist-*` options in the profile's parameters. This can be useful to e.g.
maintain an externally updated list that is not hardcoded into the NixOS
configuration. If you use these options, make sure the file paths are
accessible by the user that Zapret2 runs as (by default, it runs as a dynamic
user).

### Lua Files {#module-services-zapret2-configuration-lua-files}

By default, the module loads the `zapret-lib` and `zapret-antidpi` files from
the package defined by {option}`services.zapret2.package`. The list of files to
load can be customised using the {option}`services.zapret2.files` option, as
follows:

```nix
{
  services.zapret2.files = [
    "zapret-lib"
    "zapret-antidpi"
    "zapret-obfs"
    ./my-lib.lua
    "/path/to/read/at/runtime/my-lib.lua"
  ];
}
```

Each entry in the list of files can either be a path value, an absolute string
path (with the `.lua` extension), or the name of a [Zapret2 Lua library][3]
(without the `.lua` extension). For example, `zapret-lib` gets resolved to
`zapret-lib.lua` from the defined {option}`services.zapret2.package`. By
default, `zapret-lib` and `zapret-antidpi` are already included, so for the
simple case of DPI bypass using the standard libraries, configuring this option
isn't needed.

However, note that if you *do* customise this option, it overrides the default
list of files completely. So, for example, if you are writing custom Lua desync
functions, you will need to not only include your library's full path, but also
any libraries that it depends on (typically `zapret-lib`).

### Firewall {#module-services-zapret2-configuration-firewall}

Options for the generated nftables firewall configuration can be customised
under the {option}`services.zapret2.firewall` option. Since Zapret2 is a
userspace program and all network traffic originates in the kernel, all
matching network traffic has to be passed from kernel space to userspace. This
is an expensive process that can slow down network traffic if too much traffic
is processed. So, it is important to process as little traffic as possible to
maintain high network throughput. The predefined firewall already excludes
local IP ranges (as defined by RFC 1918), and the module includes a number of
options to further reduce how much traffic is passed to Zapret2:

```nix
{
  services.zapret2.firewall = {
    # The maximum number of packets *per each connection* that is passed to
    # Zapret2, where connection is defined by conntrack. So for the default
    # value of 16, it will pass the first 16 packets of the connection to
    # Zapret2 for processing. After 16 packets the firewall won't pass any
    # packets, and the connection will completely bypass Zapret2. This is
    # sufficient for most anti-DPI mangling. However if you are doing more
    # complex processing, you may have to increase this. If you are doing
    # obfuscation, you will want to set this to `null` so that every packet is
    # passed. Otherwise obfuscation will only apply to the first 16 packets.
    maxPackets = 16;

    # The interfaces on which traffic will be passed to Zapret2 for processing.
    # By default this is `null`, which matches every interface including e.g.
    # loopback and VPN tunnels, which don't need processing. You should almost
    # always set this to your actual outbound network interface(s) to prevent
    # VPN traffic on the inside of the tunnel from getting mangled.
    interfaces = [ "eth0" ];

    # Allowed TCP and UDP ports at the firewall level. Any ports not in these
    # lists will bypass processing completely. No profile can ever match ports
    # not on this list, since they are not even passed to Zapret2. By default
    # these are both `null`, meaning connections to all ports are passed.
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];

    # Internal parameters used by the firewall that mustn't be used by any
    # other application, or in your own firewall configuration, for example if
    # you are doing some kind of advanced setup on a router.
    queue = 200;
    desyncMark = "0x40000000";
  };
}
```

Since Zapret2 works using nfqueue, it's important that the queue number is not
used by any other application on the system. If the default queue number of
`200` is already used by another application, you should set the option
{option}`services.zapret2.firewall.queue` to a queue number that isn't used.

Likewise, it's also important that the desync mark used to mark
already-processed packets is also not used by any other application. Otherwise,
it may cause issues such as packet loops or some packets being ignored by the
conflicting applications. If the default desync mark of `0x40000000` is used by
another application (or within your firewall configuration), you should set the
option {option}`services.zapret2.firewall.desyncMark` to a desync mark that
isn't used. Note that the desync mark is expected to be a bitmask, i.e. it
should be a single bit. As such, the option uses a string instead of a number,
and the module checks that it only has a single bit set in it.

The firewall configuration in the module only supports nftables, it does not
support iptables. If you wish to use iptables, or otherwise want to define your
own firewall configuration (for example, if you are running Zapret2 server-side
instead of client-side), you can disable the built-in firewall configuration by
setting {option}`services.zapret2.firewall.configureAutomatically` to `false`.
Note that, even if the option is disabled, the module still uses the queue
number and desync mark defined in the module's options, as they are passed as
command-line arguments to Zapret2. None of the other firewall options are used.

[1]: https://github.com/bol-van/zapret2/blob/master/docs/manual.en.md
[2]: https://github.com/bol-van/zapret2/blob/master/docs/manual.en.md#traffic-processing-scheme
[3]: https://github.com/bol-van/zapret2/tree/master/lua

