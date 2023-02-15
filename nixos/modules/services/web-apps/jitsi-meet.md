# Jitsi Meet {#module-services-jitsi-meet}

With Jitsi Meet on NixOS you can quickly configure a complete,
private, self-hosted video conferencing solution.

## Basic usage {#module-services-jitsi-basic-usage}

A minimal configuration using Let's Encrypt for TLS certificates looks like this:
```
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

## Configuration {#module-services-jitsi-configuration}

Here is the minimal configuration with additional configurations:
```
{
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi.example.com";
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
