## Environment and secret maangement {#sec-systemd-environment-and-secrets}

The `environment` attribute is used to pass environment variables to the systemd service.
```
environment = {
  MY_ENV_VAR = "Something blue";
}
```

A file can be passed as well with `environmentFile`. If both are passed, `environmentFile` takes precedence over `environment`

Environment variables should not contain secret data.
The main reason being that environment variables are accessible to unpriviledged users.
See [systemd doc](https://www.freedesktop.org/software/systemd/man/systemd.exec.html#Environment=) for a more detailed explanation.

### Secret management

To pass secret data to a systemd service, systemd has the `LoadCredential` mechanism.
By passing a file path to systemd, it will make sure that the file is available to the process under a specific path.
The load credential attribute takes an id a colon and a file path
let's have a look at an [example](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/lemmy.nix#L182)
```
LoadCredential = "jwt_secret:${cfg.jwtSecretPath}";
```
Inside your application, the jwt secret will be available under `$CREDENTIALS_DIRECTORY/jwt_secret` environment variable.

Note that this requires your application to read secrets from a file.

If your service can only read secrets through environment variables, the best alternative is to ask the end user to pass an `environmentFile` containing the secrets.

If your service reads secrets from a configuration file, you can use the `script` attribute of your systemd service to populate that file with the secrets before starting the service.
[example in nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/lemmy.nix#L172)
