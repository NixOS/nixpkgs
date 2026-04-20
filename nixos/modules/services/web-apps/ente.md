# Ente.io {#module-services-ente}

[Ente](https://ente.io/) is a service that provides a fully open source,
end-to-end encrypted platform for photos and videos.

## Quickstart {#module-services-ente-quickstart}

To host ente, you need the following things:
- An S3-compatible object storage server (either an external provider or a
  self-hosted one such as [garage](#module-services-garage)). From your
  storage provider you will need:
  - the S3 endpoint URL
  - a bucket name
  - an access key ID and secret access key with read/write access to the bucket
- Several subdomains pointing to your server:
  - accounts.example.com
  - albums.example.com
  - api.example.com
  - cast.example.com
  - photos.example.com

Once you have an S3 endpoint, bucket and credentials, configure ente as follows:

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
      # You can hide secrets by setting xyz._secret = file instead of xyz = value.
      # Make sure to not include any of the secrets used here directly
      # in your config. They would be publicly readable in the nix store.
      # Use agenix, sops-nix or an equivalent secret management solution.
      settings = {
        s3 = {
          use_path_style_urls = true;
          b2-eu-cen = {
            # The S3 endpoint, bucket and credentials from your storage provider
            endpoint = "https://s3.example.com";
            # Must be us-east-1 as it is required internally by ente
            region = "us-east-1";
            bucket = "ente";
            key._secret = "/run/secrets/s3-access-key-id";
            secret._secret = "/run/secrets/s3-secret-access-key";
          };
        };
        key = {
          # generate with: openssl rand -base64 32
          encryption._secret = pkgs.writeText "encryption" "T0sn+zUVFOApdX4jJL4op6BtqqAfyQLH95fu8ASWfno=";
          # generate with: openssl rand -base64 64
          hash._secret = pkgs.writeText "hash" "g/dBZBs1zi9SXQ0EKr4RCt1TGr7ZCKkgrpjyjrQEKovWPu5/ce8dYM6YvMIPL23MMZToVuuG+Z6SGxxTbxg5NQ==";
        };
        # generate with: openssl rand -base64 32
        jwt.secret._secret = pkgs.writeText "jwt" "i2DecQmfGreG6q1vBj5tCokhlN41gcfS2cjOs9Po-u8=";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
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

## iOS background sync {#module-services-ente-ios-background-sync}

On iOS, background sync is achived via a silent notification sent by the server
every 30 minutes that allows the phone to sync for about 30 seconds, enough for
all but the largest videos to be synced on background (if the app is brought to
foreground though, sync will resume as normal). To achive this however, a
Firebase account is needed. In the settings option, configure credentials-dir
to point towards the directory where the JSON containing the Firebase
credentials are stored.

```nix
{
  # This directory should contain your fcm-service-account.json file
  services.ente.api.settings = {
    credentials-dir = "/path/to/credentials";
    # [...]
  };
}
```
