# Documenso {#module-services-documenso}

Documenso is an open-source digital signature platform, offering a
cost-effective and customizable alternative to proprietary solutions like
DocuSign.

## Quickstart {#module-services-documenso-quickstart}

To run documenso in a non-production environment use this configuration.

```
{
  services.documenso = {
    enable = true;
  };
}
```

If you want to create some initial database content including an admin user run
the following command:

```ShellSession
systemctl start documenso-seed-database
```

## Advanced configuration

Checkout all available options in upstream
[.env.example](https://github.com/documenso/documenso/blob/main/.env.example).
You can set a custom environment file using the option `environmentFile`. Use
this method the setup database connection and other settings, without storing
secrets in Nix Store, e.g. using Age or Sops.

```
{
  services.documenso = {
    enable = true;
    environmentFile = ./documenso.env;
  };
}
```
