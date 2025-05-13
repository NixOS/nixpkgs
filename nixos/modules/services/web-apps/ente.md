# Ente.io {#module-services-ente}

[Ente](https://ente.io/) is a service that provides a fully open source,
end-to-end encrypted platform for photos and videos.

## Quickstart {#module-services-ente-quickstart}

To host ente, you need the following things:
- S3 storage server (either external or self-hosted via minio)
- Several subdomains pointing to your server:
  - accounts.example.com
  - albums.example.com
  - api.example.com
  - cast.example.com
  - photos.example.com
  - s3.example.com

The following example shows how to setup ente with a self-hosted S3 storage via minio.
You can host the minio s3 storage on the same server as ente, but as this isn't
a requirement the example shows the minio and ente setup separately.
We assume that the minio server will be reachable at `https://s3.example.com`.

```nix
{
  # Enable minio
  services.minio = {
    enable = true;
    # This must match the region in ente's config!
    region = "us-east-1";
    # Please use agenix or sops-nix to store a secret file containing
    # your desired minio root user and password.
    #
    # MINIO_ROOT_USER=your_root_user
    # MINIO_ROOT_PASSWORD=a_randomly_generated_long_password
    rootCredentialsFile = "/run/secrets/minio-credentials-full";
  };

  systemd.services.minio.environment.MINIO_SERVER_URL = "https://s3.example.com";

  # Proxy for minio
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    recommendedProxySettings = true;
    virtualHosts."s3.example.com" = {
      forceSSL = true;
      useACME = true;
      locations."/".proxyPass = "http://localhost:9000";
      # determine max file upload size
      extraConfig = ''
        client_max_body_size 16G;
        proxy_buffering off;
        proxy_request_buffering off;
      '';
    };
  };
}
```

And the configuration for ente:

```nix
{
  services.ente = {
    web = {
      enable = true;
      domains = {
        accounts = "accounts.example.com";
        albums = "albums.example.com";
        cast = "cast.example.com";
        photos = "photos.example.com";
      };
    };
    api = {
      enable = true;
      nginx.enable = true;
      # Create a local postgres database and set the necessary config in ente
      enableLocalDB = true;
      domain = "api.example.com";
      settings = {
        s3 = {
          use_path_style_urls = true;
          b2-eu-cen = {
            endpoint = "https://s3.example.com";
            region = "us-east-1";
            bucket = "b2-eu-cen";
          };
        };
      };
      # All of these are secrets, please make sure to not include them directly
      # in the config. They would be publicly readable in the nix store.
      # Use agenix, sops-nix or an equivalent secret management solution.
      settingsSecret = {
        s3.b2-eu-cen = {
          key = pkgs.writeText "minio_user" "minio_user";
          secret = pkgs.writeText "minio_pw" "minio_pw";
        };
        key = {
          encryption = pkgs.writeText "encryption" "T0sn+zUVFOApdX4jJL4op6BtqqAfyQLH95fu8ASWfno=";
          hash = pkgs.writeText "hash" "g/dBZBs1zi9SXQ0EKr4RCt1TGr7ZCKkgrpjyjrQEKovWPu5/ce8dYM6YvMIPL23MMZToVuuG+Z6SGxxTbxg5NQ==";
        };
        jwt.secret = pkgs.writeText "jwt" "i2DecQmfGreG6q1vBj5tCokhlN41gcfS2cjOs9Po-u8=";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    recommendedProxySettings = true; # This is important!
    virtualHosts."accounts.${domain}".enableACME = true;
    virtualHosts."albums.${domain}".enableACME = true;
    virtualHosts."api.${domain}".enableACME = true;
    virtualHosts."cast.${domain}".enableACME = true;
    virtualHosts."photos.${domain}".enableACME = true;
  };
}
```

If you have a mail server or smtp relay, you can optionally configure
`services.ente.api.settings.smtp` so ente can send you emails (registration code and possibly
other events). This is optional.

After starting the minio server, make sure the bucket exists:

```
mc config host add minio https://s3.example.com root_user root_password --api s3v4
mc mb -p minio/b2-eu-cen
```

Now ente should be ready to go under `https://photos.example.com`.

## Registering users {#module-services-ente-registering-users}

Now you can open photos.example.com and register your user(s).
Beware that the first created account will be considered to be the admin account,
which among some other things allows you to use `ente-cli` to increase storage limits for any user.

If you have configured smtp, you will get a mail with a verification code,
otherwise you can find the code in the server logs.

```
journalctl -eu ente
[...]
ente # [  157.145165] ente[982]: INFO[0141]email.go:130 sendViaTransmail Skipping sending email to a@a.a: Verification code: 134033
```

After you have registered your users, you can set
`settings.internal.disable-registration = true;` to prevent
further signups.

## Increasing storage limit {#module-services-ente-increasing-storage-limit}

By default, all users will be on the free plan which is the only plan
available. While adding new plans is possible in theory, it requires some
manual database operations which isn't worthwhile. Instead, use `ente-cli`
with your admin user to modify the storage limit.
