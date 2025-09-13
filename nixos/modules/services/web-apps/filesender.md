# FileSender {#module-services-filesender}

[FileSender](https://filesender.org/software/) is a software that makes it easy to send and receive big files.

## Quickstart {#module-services-filesender-quickstart}

FileSender uses [SimpleSAMLphp](https://simplesamlphp.org/) for authentication, which needs to be configured separately.

Minimal working instance of FileSender that uses password-authentication would look like this:

```nix
let
  format = pkgs.formats.php { };
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.filesender = {
    enable = true;
    localDomain = "filesender.example.com";
    configureNginx = true;
    database.createLocally = true;

    settings = {
      auth_sp_saml_authentication_source = "default";
      auth_sp_saml_uid_attribute = "uid";
      storage_filesystem_path = "<STORAGE PATH FOR UPLOADED FILES>";
      admin = "admin";
      admin_email = "admin@example.com";
      email_reply_to = "noreply@example.com";
    };
  };
  services.simplesamlphp.filesender = {
    settings = {
      "module.enable".exampleauth = true;
    };
    authSources = {
      admin = [ "core:AdminPassword" ];
      default = format.lib.mkMixedArray [ "exampleauth:UserPass" ] {
        "admin:admin123" = {
          uid = [ "admin" ];
          cn = [ "admin" ];
          mail = [ "admin@example.com" ];
        };
      };
    };
  };
}
```

::: {.warning}
Example above uses hardcoded clear-text password, in production you should use other authentication method like LDAP. You can check supported authentication methods [in SimpleSAMLphp documentation](https://simplesamlphp.org/docs/stable/simplesamlphp-idp.html).
:::
