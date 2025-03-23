# Jitsi Meet {#module-services-jitsi-meet}

With Jitsi Meet on NixOS you can quickly configure a complete,
private, self-hosted video conferencing solution.

## Basic usage {#module-services-jitsi-basic-usage}

A minimal configuration using Let's Encrypt for TLS certificates looks like this:
```nix
{
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi.example.com";
  };
  services.jitsi-videobridge.openFirewall = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme.email = "me@example.com";
  security.acme.acceptTerms = true;
}
```

Jitsi Meet depends on the Prosody XMPP server only for message passing from
the web browser while the default Prosody configuration is intended for use
with standalone XMPP clients and XMPP federation. If you only use Prosody as
a backend for Jitsi Meet it is therefore recommended to also enable
{option}`services.jitsi-meet.prosody.lockdown` option to disable unnecessary
Prosody features such as federation or the file proxy.

## Configuration {#module-services-jitsi-configuration}

Here is the minimal configuration with additional configurations:
```nix
{
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi.example.com";
    prosody.lockdown = true;
    config = {
      enableWelcomePage = false;
      prejoinPageEnabled = true;
      defaultLang = "fi";
    };
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
      SHOW_WATERMARK_FOR_GUESTS = false;
    };
  };
  services.jitsi-videobridge.openFirewall = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme.email = "me@example.com";
  security.acme.acceptTerms = true;
}
```
