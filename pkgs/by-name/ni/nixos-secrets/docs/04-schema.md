## The secrets schema

Throughout this section, we'll use "unevaluated NixOS configuration" to refer to configuration files containing NixOS modules (think `/etc/nixos/configuration.nix`). On the other hand, a "(pre-)evaluated NixOS configuration" is one that has already been passed to `<nixpkgs/nixos/lib/eval-config.nix>` (or `nixpkgs.lib.nixosSystem` when using flakes).

Earlier on we observed that the secrets CLI can take in NixOS configurations as an argument. Of course, this by itself can be read in multiple ways. For example — do the configurations in question need to be evaluated already? If not, where is Nixpkgs imported from?

The CLI does accept pre-evaluated configurations (like one would, for example, expect when using flakes). When given a non-evaluated configuration, the CLI will evaluate it using the Nixpkgs available in the `NIX_PATH`. One should pre-evaluate their configuration if pinning of the Nixpkgs version is desired.

Once the configuration is evaluated, the CLI will extract the data it needs into a Nix attrset that can be directly serialized as JSON (this implies the package-set reliant script functions are evaluated with the host package set as an argument, for example) before being taken in by the Python code.

This is done by calling to the so-called [`jsonify.nix`](./nixos_secrets/nix/jsonify.nix) function. If we were to assign a type signature to the aforementioned function, it would (barring some internal arguments) look something like this:

```
jsonify : { config, pkgsHost ? null, pkgsTarget ? null } -> SecretsConfiguration
```

We've already seen what happens if `config` is given as a (possibly evaluated) NixOS configuration. If this function receives a `SecretsConfiguration` as the config argument, then the function will simply return the configuration it is given. This means one can side-step the `jsonify.nix` logic entirely and produce a Nix attrset containing the needed data by whichever means they desire (for example, as part of a tool that's totally disconnected from the NixOS module system).

The `SecretsConfiguration` type is documented as a JSON schema in [`secrets-config.schema.json`](./src/nixos_secrets/secrets-config.schema.json).

One can also sidestep going through Nix-lang altogether by using the `--json` flag to pass a JSON string satisfying the aforementioned schema

### Using separate host and target NixOS instances

One can pre-evaluate their NixOS configuration in order to pin the target's Nixpkgs instance. This will implicitly also set the host's Nixpkgs instance to the same value. If this is not desired (for example, when the target and host architectures differ), then one must invoke `jsonify` themselves, passing its output to the CLI (one could also side-step `jsonify` entirely, as explained above; a person doing that is assumed to already know what they're doing though!).

One can achieve the above as follows (do note that flakes are not necessary for this! I chose to provide a flakes-based example since none of the examples above used them):

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = inputs: {
    nixosConfigurations.example = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        # The config goes here
      ];
    };

    secretsConfigurations.differentArch =
      let
        pkgsHost = inputs.nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgsHost.nixos-secrets.jsonify {
        inherit pkgsHost;
        configuration = inputs.self.nixosConfigurations.example;

        # Observe that pkgsTarget is not needed, as the given configuration has
        # been pre-evaluated!
      };
  };
}
```

One would then pass the configuration to the CLI like usual (in this case, via `nixos-secrets --flake path/to/flake#secretsConfiguration.differentArch`).
