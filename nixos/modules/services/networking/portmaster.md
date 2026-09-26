# Portmaster {#module-services-portmaster}

[Portmaster](https://safing.io/portmaster/) is an application firewall that monitors and controls network connections
per application. A minimal configuration is:

```nix
{
  services.portmaster.enable = true;
}
```

The desktop client is installed in the system environment when the service is enabled and starts in the background with
graphical sessions. It is authenticated through the package's immutable binary directory. Set
`services.portmaster.settings.devmode = true` only when unrestricted browser or debugging access to
`http://127.0.0.1:817` is required.

Portmaster's binary self-updater is disabled because Nix owns the installed files. Intelligence data updates remain
enabled and are stored under {option}`services.portmaster.stateDir`.
Changing `stateDir` does not automatically move Portmaster's existing state or remove module-managed files from its old
location.

## Declarative configuration {#module-services-portmaster-declarative-configuration}

Global settings can be set with {option}`services.portmaster.settings`. Later inputs override earlier inputs in this
order: `settings`, {option}`services.portmaster.settingsFile`, then {option}`services.portmaster.secretsFile`. Use the
last option for values that must not be copied to the Nix store.

When any of these options or {option}`services.portmaster.profiles` is used, the module owns Portmaster's runtime
`config.json`. Put all desired global settings in these options; global changes made only through the UI are replaced at
the next service start.

Declarative application profiles can combine multiple packages with manually specified fingerprints. A prefix can be
added to their display names so that module-managed profiles are easy to recognize in Portmaster:

```nix
{ pkgs, ... }:
{
  services.portmaster = {
    enable = true;
    profilePrefix = "[NixOS] ";

    profiles = {
      Firefox = {
        packages = [ pkgs.firefox ];
        settings.filter.defaultAction = "permit";
      };

      Development = {
        packages = [
          {
            package = pkgs.go;
            directory = "share/go/bin";
          }
          pkgs.cargo
        ];
        settings.filter.endpoints = [ "+ .golang.org" ];
      };

      Vesktop = {
        fingerprints = [
          {
            type = "env";
            key = "CHROME_DESKTOP";
            operation = "equals";
            value = "vesktop.desktop";
          }
        ];
      };
    };
  };
}
```

Package identities use a regular expression that ignores the Nix store hash and package version and matches both the
normal executable and Nix-generated `.program-wrapped` executables. A package can be written directly or as an attribute
set with `package`, `type`, `storeNameRegex`, `directory`, `name`, `wrapped`, `strictHead`, and `strictLast` fields.
`storeNameRegex` is a regular expression fragment, while `directory` and `name` are matched literally.

Some packages start the real executable outside {file}`bin`. Specify those layouts explicitly, for example:

```nix
{ pkgs, ... }:
{
  services.portmaster.profiles = {
    Brave.packages = [
      {
        package = pkgs.brave;
        directory = "opt/brave.com/brave";
      }
    ];

    LibreWolf.packages = [
      {
        package = pkgs.librewolf;
        directory = "lib/librewolf";
      }
    ];
  };
}
```

The `packages` and `fingerprints` lists are merged, and at least one of them must be non-empty. Use manual fingerprints
when package paths alone are not enough to identify an application.

Package-name matching is a convenience, not a security boundary against local Nix users: someone who can add arbitrary
store paths can create a derivation with the same name. Use manually chosen fingerprints when that threat is relevant.

Portmaster fingerprints are alternatives: a process matches when any fingerprint matches. Broad regular expressions
can therefore match unintended applications. Removing a profile declaration does not remove a profile already imported
into Portmaster.

Changing fingerprints changes Portmaster's derived profile ID. Portmaster 2.2.1 and later can migrate existing profiles
whose fingerprints are edited, but declarative imports with a new identity can still leave the previous imported profile
behind. Stable package identities avoid that churn.
