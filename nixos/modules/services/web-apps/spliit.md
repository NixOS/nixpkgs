# Spliit {#module-services-spliit}

A webapp to share expenses with your friends and family.
Free and Open Source Alternative to Splitwise.

## Basic usage {#module-services-spliit-basic-usage}

By default the module will run spliit on port `3000` and configure the required postgres database.

```nix
{ ... }:

{
  services.spliit = {
    enable = true;
  };
}
```

It runs in the systemd service named `spliit`.

## External database {#module-services-spliit-external-database}

If you want to connect to an external database, set the connection options:

```nix
{ ... }:

{
  services.spliit = {
    enable = true;
    database = {
      createLocally = false;
      hostname= "localhost";
      name = "postgres";
      user = "postgres";
      passwordFile = /run/secrets/spliit-postgres-password;
    }
  };
}
```

## Extra config and secrets {#module-services-spliit-extra-config-and-secrets}

To configure additional features of split as described [here](https://github.com/spliit-app/spliit?tab=readme-ov-file#opt-in-features)
you can add the config:

```nix
{ ... }:

{
  services.spliit = {
    enable = true;

    settings = {
      NEXT_PUBLIC_ENABLE_EXPENSE_DOCUMENTS = true;
      S3_UPLOAD_BUCKET = "name-of-s3-bucket";
      S3_UPLOAD_REGION = "us-east-1";
    };

    # A .env file with your secrets (S3_UPLOAD_KEY, etc)
    secretFile = /run/secrets/spliit-secret-settings;
  };
}
```
