# Flake Configuration Source Information {#sec-flake-source-info}

Perhaps the most significant advantage of a flake-based configuration
over a legacy configuration is the ability to record the revision of
the repository from which a NixOS system is built, as shown in the
following example:

```
$ nixos-version --json
{"configurationRevision":"f25d2e456a5a7b2798620e41e183739fdaf057ed"
,"nixosVersion":"22.11.20220715.a2ec1c5"
,"nixpkgsRevision":"a2ec1c5fca5f131a26411dd0c18a59fcda3bc974"}
```

To enable this feature, set
[](#opt-system.nixos.configuration.sourceInfo) to the source
information of the flake:

```nix
{
  inputs.nixpkgs.url = ...;
  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      host = nixpkgs.lib.nixosSystem {
        modules = [
          { system.nixos.configuration.sourceInfo = self.sourceInfo; }
        ] ++ ...;
      };
    };
  };
}
```

Note that this feature is not enabled by default.  That is because in
such a case that the repository changes but a specific system's
configuration, `host` in the above snippet for example, does not
change, there could be extra unnecessary generations.  Keep this in
mind while using it.
