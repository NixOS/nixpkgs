## Store/generator backends

Store backends are specified in a similar manner to prompt backends:

```nix
{
  # For a full example, see the provided examples
  secrets.backends.store.plain = { };
}
```

### Get

Unlike prompt backends, store backends must provide a number of different scripts. The most basic of said scripts are `get` and `set`. The former is given the secret name and the file name as an argument, and must return the content of said backend to `$out`. The CLI needs to be able to access any of the secrets at runtime in order for secret dependencies to work out. The `get` script can be omitted as long as the backend in question is never used as a dependency for another generator.

```nix
{
  secrets.backends.store.plain.get =
    pkgs:
    pkgs.writeScript "secrets-plain-get" ''
      #!/bin/sh
      export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
      cat /var/lib/nixos-secrets-plain/generators/"$1"/files/"$2" > "$out"
    '';
}
```

### Set

The `set` script, on the other hand, is mandatory. As with the `get` script, the `set` script is given a secret name and a file name as an argument, together with a secret at `$in`, and is responsible for saving said secret for later.

```nix
{
  secrets.backends.store.plain.set =
    pkgs:
    pkgs.writeScript "secrets-plain-set" ''
      #!/bin/sh
      export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
      cat "$in" > /var/lib/nixos-secrets-plain/generators/"$1"/files/"$2"
    '';
}
```

### Garbage collection

The user might remove secrets from their configuration, yet the respective secrets will still exist on disk. The CLI offers the `collect-garbage` command for handling this exact scenario. In order to support garbage collection, a backend must provide the `list` and `delete` scripts.

The `delete` script is given a secret and a file name as an argument, and must delete the given file (you might notice a theme here).

The `list` argument must print (to standard out) a list of every file it currently finds on disk (or in the cloud, or wherever the secrets are stored). The format of the output goes as follows: every line contains a space separated list where the first element is the secret name, and the second element is the file name (_not_ the full file path!). For example, the output of `list` could look like this:

```txt
gen-foo file-1
gen-foo file-2
gen-bar file-3
gen-goo file-4
```

These operations are not difficult to implement in the easy case of managing a single machine. One thing to note is that backends might want to share secrets across multiple machines. The aforementioned `list` command must then only return secrets related to the given machine/configuration! (otherwise the CLI will ask the backend to delete every one of the files it finds in the list but not in the given machine/configuration).

### Performing automatic updates

Backends might need to perform maintenance work on the secret files on disk. Think re-keying when using `age` keys and a new recipient is added, or perhaps rotating API keys when storing the secrets remotely. A backend can provide a `fixup` script, which will be run after each `generate` command. This script will be run regardless of whether any of the files involved got updated/regenerated.

Said script can perform side effects, yet must remain idempotent. The script is expected to perform the necessary updates to every file within a single invocation, and is given a list of files to act on as argument, in the same format as the output of the `list` script (although the actual content might of course be different).

### Deployment

Backends can also provide `deploy.local` and `deploy.remote` scripts. Note that each secret file has a `deploy` flag that is on by default. Users can choose to disable deployment for any of their secrets by setting said flag to `false`. This might be useful (for example) when handling secrets that are only meant to be used as inputs to other generators, but must not have their outputs deployed right away. A backend can choose to not provide either of the scripts above.

The names of the two scripts might give away their intended purpose. The former is meant for deploying the secrets to a system that has its system root mounted to the current machine's filesystem, and will therefore receive a path to the system root as its first argument. The latter is meant for deploying to fully remote systems.

As an example, the former will usually receive `/` as its first argument (when deploying to the current machine), although this is not always the case. For example, consider a live CD where `nixos-install` has finished running, yet the newly constructed machine is not currently running either (and thus cannot be accessible over SSH or whatnot).

Both scripts receive a list of secrets to deploy, via standard input. The list is given in the same format used for the output of the `list` script (although the actual content might of course be different). Deployment scripts do not follow the pattern of taking in a secret and a file name as arguments. This is because batched operations are preferred in scenarios like that of a person using passphrase-protected SSH keys or touch-protected hardware keys.

### Output paths

Last but not least, backends can set an optional `fileModule` that will be imported by each file corresponding to the given backend. This module is usually responsible for setting the `path` attribute, representing the location the file will be deployed to on the target machine (this can, for example, be referenced from other parts of the given NixOS config).

For example, the plain backend might work as follows:

```nix
{
  secrets.backends.store.plain.fileModule =
    { secret, name, ... }:
    {
      path = "${config.secrets.settings.store.plain.targetDirectory}/${secret.name}/${name}";
    };
}
```

### Per-backend options

Backends might require additional configuration (e.g. where should the files go on the host machine? What keys should they be encrypted with? Etc). While a backend is free to put those options anywhere (backends are full-blown NixOS modules, after all!), the convention is to put them under `secrets.settings.store.*` and `secrets.settings.prompt.*` respectively.

### Per-secret or per-file backend options

Backends will commonly need to define custom per-generator or per-file options. While the latter can already be achieved with the aforementioned `fileModule`, the former needs to currently be done by hand. Since the NixOS module system merges submodules defined in the same location, one can achieve the above as follows:

```nix
{
  # Extracted from the age backend
  options.secrets.store = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.age.identity.host = lib.mkOption {
          default = config.secrets.age.identity.host;
          type = lib.types.str;
          description = ''
            Path to the age private key file for decryption on the host machine
          '';
        };
      }
    );
  };
}
```

### Environment variables

Backends receive additional environment variables one can read when things like Git-root detection are required. In particular, `NIXOS_SECRETS_FLAKE` will contain the value passed to `--flake` and `NIXOS_SECRETS_CONFIG` will contain the path given to `--json` or `--file` respectively.

### Available backends

We are not currently planning to ship a production-ready backend alongside the CLI (although this might change once the CLI stabilizes). The goal of the interface is to be lean enough such that anyone can write a simple backend meeting their needs in their language of choice. Still, four (currently somewhat scuffed) example backends can be found in [`example/common`](../../../../nixos/modules/security/secrets/example/common).

### Metadata

The `nixos-secrets` will attach additional metadata to each secret. The metadata is there in order to detect dependency changes, recover from crashes mid-generation, and so on. The metadata is stored in a file named `.nixos-secrets-metadata`. Store backends do not require special logic/scripts for handling metadata files. Indeed, to a backend, the metadata is merely another file associated with the given secret (although one the user hasn't manually declared).

### Failure modes

The aforementioned metadata system should protect one's secrets from most crashes. Still, this system is not perfect. In particular, spooky things might happen if multiple instances of the CLI are invoked simultaneously (we should perhaps consider some sort of locking mechanism in the future, although that would complicate things a lot, especially when the CLI's instances are run from separate machines).

More importantly, a backend's `set` script should perform the update in an atomic matter, when possible. The metadata only being partially written could cause issues for future runs of the program (although it will most likely cause the given secret to be regenerated).
