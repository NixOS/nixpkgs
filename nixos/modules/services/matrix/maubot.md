# Maubot {#module-services-maubot}

[Maubot](https://github.com/maubot/maubot) is a plugin-based bot
framework for Matrix.

## Configuration {#module-services-maubot-configuration}

1. Set [](#opt-services.maubot.enable) to `true`. The service will use
   SQLite by default.
2. If you want to use PostgreSQL instead of SQLite, do this:

   ```nix
   {
     services.maubot.settings.database = "postgresql://maubot@localhost/maubot";
   }
   ```

   If the PostgreSQL connection requires a password, you will have to
   add it later on step 8.
3. If you plan to expose your Maubot interface to the web, do something
   like this:
   ```nix
   {
     services.nginx.virtualHosts."matrix.example.org".locations = {
       "/_matrix/maubot/" = {
         proxyPass = "http://127.0.0.1:${toString config.services.maubot.settings.server.port}";
         proxyWebsockets = true;
       };
     };
     services.maubot.settings.server.public_url = "matrix.example.org";
     # do the following only if you want to use something other than /_matrix/maubot...
     services.maubot.settings.server.ui_base_path = "/another/base/path";
   }
   ```
4. Optionally, set `services.maubot.pythonPackages` to a list of python3
   packages to make available for Maubot plugins.
5. Optionally, set `services.maubot.plugins` to a list of Maubot
   plugins (full list available at https://plugins.maubot.xyz/):
   ```nix
   {
     services.maubot.plugins = with config.services.maubot.package.plugins; [
       reactbot
       # This will only change the default config! After you create a
       # plugin instance, the default config will be copied into that
       # instance's config in Maubot's database, and further base config
       # changes won't affect the running plugin.
       (rss.override {
         base_config = {
           update_interval = 60;
           max_backoff = 7200;
           spam_sleep = 2;
           command_prefix = "rss";
           admins = [ "@chayleaf:pavluk.org" ];
         };
       })
     ];
     # ...or...
     services.maubot.plugins = config.services.maubot.package.plugins.allOfficialPlugins;
     # ...or...
     services.maubot.plugins = config.services.maubot.package.plugins.allPlugins;
     # ...or...
     services.maubot.plugins = with config.services.maubot.package.plugins; [
       (weather.override {
         # you can pass base_config as a string
         base_config = ''
           default_location: New York
           default_units: M
           default_language:
           show_link: true
           show_image: false
         '';
       })
     ];
   }
   ```
6. Start Maubot at least once before doing the following steps (it's
   necessary to generate the initial config).
7. If your PostgreSQL connection requires a password, add
   `database: postgresql://user:password@localhost/maubot`
   to `/var/lib/maubot/config.yaml`. This overrides the Nix-provided
   config. Even then, don't remove the `database` line from Nix config
   so the module knows you use PostgreSQL!
8. To create a user account for logging into Maubot web UI and
   configuring it, generate a password using the shell command
   `mkpasswd -R 12 -m bcrypt`, and edit `/var/lib/maubot/config.yaml`
   with the following:

   ```yaml
   admins:
       admin_username: $2b$12$g.oIStUeUCvI58ebYoVMtO/vb9QZJo81PsmVOomHiNCFbh0dJpZVa
   ```

   Where `admin_username` is your username, and `$2b...` is the bcrypted
   password.
9. Optional: if you want to be able to register new users with the
   Maubot CLI (`mbc`), and your homeserver is private, add your
   homeserver's registration key to `/var/lib/maubot/config.yaml`:

   ```yaml
   homeservers:
       matrix.example.org:
           url: https://matrix.example.org
           secret: your-very-secret-key
   ```
10. Restart Maubot after editing `/var/lib/maubot/config.yaml`,and
    Maubot will be available at
    `https://matrix.example.org/_matrix/maubot`. If you want to use the
    `mbc` CLI, it's available using the `maubot` package (`nix-shell -p
    maubot`).
