# Blackfire profiler {#module-services-blackfire}

*Source:* {file}`modules/services/development/blackfire.nix`

*Upstream documentation:* <https://blackfire.io/docs/introduction>

[Blackfire](https://blackfire.io) is a proprietary tool for profiling applications. There are several languages supported by the product but currently only PHP support is packaged in Nixpkgs. The back-end consists of a module that is loaded into the language runtime (called *probe*) and a service (*agent*) that the probe connects to and that sends the profiles to the server.

To use it, you will need to enable the agent and the probe on your server. The exact method will depend on the way you use PHP but here is an example of NixOS configuration for PHP-FPM:
```
let
  php = pkgs.php.withExtensions ({ enabled, all }: enabled ++ (with all; [
    blackfire
  ]));
in {
  # Enable the probe extension for PHP-FPM.
  services.phpfpm = {
    phpPackage = php;
  };

  # Enable and configure the agent.
  services.blackfire-agent = {
    enable = true;
    settings = {
      # You will need to get credentials at https://blackfire.io/my/settings/credentials
      # You can also use other options described in https://blackfire.io/docs/up-and-running/configuration/agent
      server-id = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
      server-token = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    };
  };

  # Make the agent run on start-up.
  # (WantedBy= from the upstream unit not respected: https://github.com/NixOS/nixpkgs/issues/81138)
  # Alternately, you can start it manually with `systemctl start blackfire-agent`.
  systemd.services.blackfire-agent.wantedBy = [ "phpfpm-foo.service" ];
}
```

On your developer machine, you will also want to install [the client](https://blackfire.io/docs/up-and-running/installation#install-a-profiling-client) (see `blackfire` package) or the browser extension to actually trigger the profiling.
