# Secrets {#sec-secrets}

Nix stores every file in clear text in the nix store. There is no encrypted sub-path.
This means one should never reference secrets by using the path syntax `${./path/to/a/file}`
as that file's content is stored in the nix store.

Secrets should instead be referenced by path `"/path/to/a/file"` with modules providing options accepting the `string` type.
Those files need to be then copied to or generated on
the target host by out of band tools such as those listed [in the wiki](https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes).

## Configuration Files {#sec-secrets-configuration-files}

In the case of services requiring the secrets to live inside their configuration file,
nixpkgs provides the `genSecretsReplacement` function
and its `gen*SecretsReplacement` specializations to help modules implement this safely with minimal effort.
These functions generate configuration files with secrets embedded in clear text
while avoiding storing the clear text secrets in the nix store.
Out of band tools are still needed to copy or generate those secrets on the target host as mentioned above.

The functions expect multiple arguments which are covered in details in their respective documentation.
To follow this section, it is enough to know they accept:

- The configuration file as nix expression,
- a generator function `a -> string` to generate the configuration from in wanted format,
- the location where the final configuration with embedded secrets should live,
- and others for fine tuning.

The nix expression representing the configuration is an arbitrary value of nested lists and attrsets - which is fully compatible
with [freeform type options](https://nixos.org/nixos/manual/index.html#sec-freeform-modules) -
where secrets are identified as an attrset containing the `_secret` attr:

```nix
{
  mysecret = {
    _secret = "/run/secrets/path/to/secret";
  };
}
```

The above `{ _secret = "/run/secrets/path/to/secret" }` attrset defines
where the decrypted secret will be available from on the target host.

The function then replaces all occurrences of such an attrset with a uniquely identified placeholder
string whose exact value is an implementation detail:

```nix
{
  mysecret = "a unique placholder";
}
```

From this new representation, the function generates the configuration file in the expected output format
and this gets stored in the nix store.
For example in JSON format:

```json
{
  "mysecret": "a unique placholder"
}
```

The function then returns a bash script whose purpose is to replace all those placeholders
with the secret coming from the path in the `_secret` attr.
Usually this bash script is placed inside the `serviceConfig.ExecStartPre` of the systemd service
needing the configuration file. See the next sections for examples.

Assuming the file `/run/secrets/path/to/secret` exists on the target host and contains
`my super secret`, running the bash script returned by the function will output the following configuration
in the expected location:

```json
{
  "mysecret": "my super secret"
}
```

### JSON configuration file example {#sec-secrets-configuration-files-json}

For JSON configuration files, the `genJqSecretsReplacement` function can be used.
The following snippet only shows parts related to using this function
and does not present best practices related to other parts of module creation and maintenance.

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.myservice;

  settingsFormat = pkgs.formats.json { };
  settingsFile = "/run/myservice/myconfiguration.json";

  inherit (lib)
    mkOption
    types
    ;
in
{
  options.services.myservice = {
    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
    };
  };

  config = {
    systemd.services.myservice =
      let
        secretsReplacement = utils.genJqSecretsReplacement { } cfg.settings settingsFile;
      in
      {
        preStart = secretsReplacement.script;
      };
  };
}
```

Note that the systemd service must have permission to read the files containing the secrets.
Either the owner of the files must match the owner of the systemd service,
or systemd's `LoadCredential` feature can be used as shown in the next section.

We recommend against prefixing the `preStart` script with the bang `!`
because this gives root access to the script and is unnecessarily permissive.

### JSON configuration file LoadCredential example {#sec-secrets-configuration-files-json-loadcredential}

To avoid any permission issue for reading the files containing the secrets,
when using systemd the easiest is to use its `LoadCredential` feature.

The `gen*SecretsReplacement` functions can be configured to instead return an attrset
containing the bash script in the `script` attr and what to give to `LoadCredential`
in the `credentials` attr.

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.myservice;

  settingsFormat = pkgs.formats.json { };
  settingsFile = "/run/myservice/myconfiguration.json";

  inherit (lib)
    mkOption
    types
    ;
in
{
  options.services.myservice = {
    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
    };
  };

  config = {
    systemd.services.myservice =
      let
        secretsReplacement = utils.genJqSecretsReplacement {
          loadCredential = true;
        } cfg.settings settingsFile;
      in
      {
        preStart = secretsReplacement.script;
        serviceConfig.LoadCredential = secretsReplacement.credentials;
      };
  };
}
```

### JSON configuration file structured secret example {#sec-secrets-configuration-files-json-structured-secret}

By default, the secrets are embedded as strings in the JSON file.
It is also possible to embed secrets that are themselves JSON instead.
This is configurable per secret.

If the file `"/path/to/secret"` contains the JSON document:

```json
[
  { "a": "topsecretpassword1234" },
  { "b": "topsecretpassword5678" }
]
```

The following function call:

```nix
genSecretsReplacement toJSON { } {
  example = [
    {
      irrelevant = "not interesting";
    }
    {
      ignored = "ignored attr";
      relevant = {
        secret = {
          _secret = "/path/to/secret";
          quote = false;
        };
      };
    }
  ];
} "/path/to/output.json"
```

would generate a script that outputs the following JSON file at `/path/to/output.json`:

```json
{
  "example": [
    {
      "irrelevant": "not interesting"
    },
    {
      "ignored": "ignored attr",
      "relevant": {
        "secret": [
          { "a": "topsecretpassword1234" },
          { "b": "topsecretpassword5678" }
        ]
      }
    }
  ]
}
```
