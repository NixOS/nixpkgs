# Firefox Sync server {#module-services-firefox-syncserver}

A storage server for Firefox Sync that you can easily host yourself.

## Quickstart {#module-services-firefox-syncserver-quickstart}

The absolute minimal configuration for the sync server looks like this:

```nix
{
  services.mysql.package = pkgs.mariadb;

  services.firefox-syncserver = {
    enable = true;
    secrets = builtins.toFile "sync-secrets" ''
      SYNC_MASTER_SECRET=this-secret-is-actually-leaked-to-/nix/store
    '';
    singleNode = {
      enable = true;
      hostname = "localhost";
      url = "http://localhost:5000";
    };
  };
}
```

This will start a sync server that is only accessible locally on the following url: `http://localhost:5000/1.0/sync/1.5`.
See [the dedicated section](#module-services-firefox-syncserver-clients) to configure your browser to use this sync server.

::: {.warning}
This configuration should never be used in production. It is not encrypted and
stores its secrets in a world-readable location.
:::

## More detailed setup {#module-services-firefox-syncserver-configuration}

The `firefox-syncserver` service provides a number of options to make setting up
small deployment easier. These are grouped under the `singleNode` element of the
option tree and allow simple configuration of the most important parameters.

Single node setup is split into two kinds of options: those that affect the sync
server itself, and those that affect its surroundings. Options that affect the
sync server are `capacity`, which configures how many accounts may be active on
this instance, and `url`, which holds the URL under which the sync server can be
accessed. The `url` can be configured automatically when using nginx.

Options that affect the surroundings of the sync server are `enableNginx`,
`enableTLS` and `hostname`. If `enableNginx` is set the sync server module will
automatically add an nginx virtual host to the system using `hostname` as the
domain and set `url` accordingly. If `enableTLS` is set the module will also
enable ACME certificates on the new virtual host and force all connections to
be made via TLS.

For actual deployment it is also recommended to store the `secrets` file in a
secure location.

## Configuring clients to use this server {#module-services-firefox-syncserver-clients}

### Firefox desktop {#module-services-firefox-syncserver-clients-desktop}
To configure a desktop version of Firefox to use your server, navigate to
`about:config` in your Firefox profile and set
`identity.sync.tokenserver.uri` to `https://myhostname:5000/1.0/sync/1.5`.

### Firefox Android {#module-services-firefox-syncserver-clients-android}
To configure an Android version of Firefox to use your server:
* First ensure that you are disconnected from you Mozilla account.
* Go to App Menu > Settings > About Firefox and click the logo 5 times. You
  should see a “debug menu enabled” notification.
* Back to the main menu, a new menu "sync debug" should have appeared.
* In this menu, set "custom sync server" to `https://myhostname:5000/1.0/sync/1.5`.

::: {.warning}
Changes to this configuration value are ignored if you are currently connected to your account.
:::

* Restart the application.
* Log in to your account.
