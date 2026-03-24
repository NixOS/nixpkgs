# go-avahi-cname {#module-services-go-avahi-cname}

[go-avahi-cname](https://github.com/grishy/go-avahi-cname) allows you to publish CNAME records that point to your local host via the multicast DNS (mDNS) service provided by `avahi-daemon`.

## Motivation {#module-services-go-avahi-cname-motivation}

The use of a mDNS service, such as `avahi`, allows for device-to-device communication via domain names without having to use a centralised DNS server.
However, the [RFC](https://datatracker.ietf.org/doc/html/rfc6762) for mDNS does not provide delegation of subdomains like traditional DNS does.
In short, `hostname.local` will work over mDNS whereas `subdomain.hostname.local` will not.
The program [go-avahi-cname](https://github.com/grishy/go-avahi-cname) enables subdomains over mDNS for a list of specified subdomains.

This service, `services.go-avahi-cname`, provides a background implementation of the program, with a module based interface.

## Configuration {#module-services-go-avahi-cname-configuration}

### Mode {#module-services-go-avahi-cname-configuration-mode}

The service supports two modes: `interval-publishing` and `subdomain-reply`.
Only one mode can be active at any one time.
Set the mode by configuring `services.go-avahi-cname.mode` with the desired value.

In `interval-publishing` mode, the service will periodically broadcast CNAME records for the subdomains to the local network.
In `subdomain-reply` mode, the service listens for mDNS requests and responds with the corresponding hostname.
For example, a request for `git.hostname.local` will be resolved to `hostname.local`.

### Prerequisites {#module-services-go-avahi-cname-configuration-prerequisites}

The service requires that the `avahi` service be enabled with publishing of user services and the mDNS NSS plug-in active.
This provides the system mDNS implementation.

Additionally, due to the use of `DynamicUser` in the `systemd` service, the `dbus` implementation should be set to `broker`.

```nix
{
  services.dbus.implementation = "broker";

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
```

### Basic Implementation {#module-services-go-avahi-cname-configuration-basic-implementation}

This example enables the service in `interval-publishing` mode for a single subdomain `git`, which will resolve to `<hostname>.local` on your local network.

```nix
{
  services.go-avahi-cname = {
    enable = true;
    mode = "interval-publishing";
    subdomains = [ "git" ];
  };
}
```
