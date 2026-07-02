# Secrets {#sec-secrets}

Nix stores every file in clear text in the nix store. There is no
encrypted sub-path. This means one should never reference secrets by
using the path syntax `${./path/to/a/file}` as that file's content is
stored in the nix store.

Secrets should instead be referenced with a path string
`"/path/to/a/file"` with modules providing options accepting the
[`externalPath` type](https://nixos.org/manual/nixos/stable/#sec-option-types-basic).
Those files need to be then copied to or generated on the
target host by out of band tools such as those listed
[in the wiki](https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes).

## Configuration Files {#sec-secrets-configuration-files}

In the case of services requiring the secrets to live inside their
configuration file, nixpkgs provides the `genSecretsReplacement`
function and its `gen*SecretsReplacement` specializations to help
modules implement this safely with minimal effort.

These functions generate configuration files with secrets embedded in
clear text while avoiding storing the clear text secrets in the nix
store. Out of band tools are still needed to copy or generate those
secrets on the target host.
