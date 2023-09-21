# Secure Shell Access {#sec-ssh}

Secure shell (SSH) access to your machine can be enabled by setting:

```nix
services.openssh.enable = true;
```

By default, root logins using a password are disallowed. They can be
disabled entirely by setting
[](#opt-services.openssh.settings.PermitRootLogin) to `"no"`.

You can declaratively specify authorised RSA/DSA public keys for a user
as follows:

```nix
users.users.alice.openssh.authorizedKeys.keys =
  [ "ssh-dss AAAAB3NzaC1kc3MAAACBAPIkGWVEt4..." ];
```
