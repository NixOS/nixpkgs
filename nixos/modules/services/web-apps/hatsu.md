# Hatsu {#module-services-hatsu}

[Hatsu](https://github.com/importantimport/hatsu) is an fully-automated ActivityPub bridge for static sites.

## Quickstart {#module-services-hatsu-quickstart}

The minimum configuration to start hatsu server would look like this:

```nix
{
  services.hatsu = {
    enable = true;
    settings = {
      HATSU_DOMAIN = "hatsu.local";
      HATSU_PRIMARY_ACCOUNT = "example.com";
    };
  };
}
```

this will start the hatsu server on port 3939 and save the database in `/var/lib/hatsu/hatsu.sqlite3`.

Please refer to the [Hatsu Documentation](https://hatsu.cli.rs) for additional configuration options.
