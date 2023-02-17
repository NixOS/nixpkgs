# Writing NixOS Modules {#sec-writing-modules}

NixOS has a modular system for declarative configuration. This system
combines multiple *modules* to produce the full system configuration.
One of the modules that constitute the configuration is
`/etc/nixos/configuration.nix`. Most of the others live in the
[`nixos/modules`](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules)
subdirectory of the Nixpkgs tree.

Each NixOS module is a file that handles one logical aspect of the
configuration, such as a specific kind of hardware, a service, or
network settings. A module configuration does not have to handle
everything from scratch; it can use the functionality provided by other
modules for its implementation. Thus a module can *declare* options that
can be used by other modules, and conversely can *define* options
provided by other modules in its own implementation. For example, the
module
[`pam.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/pam.nix)
declares the option `security.pam.services` that allows other modules (e.g.
[`sshd.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/ssh/sshd.nix))
to define PAM services; and it defines the option `environment.etc` (declared by
[`etc.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/etc/etc.nix))
to cause files to be created in `/etc/pam.d`.

In [](#sec-configuration-syntax), we saw the following structure of
NixOS modules:

```nix
{ config, pkgs, ... }:

{ option definitions
}
```

This is actually an *abbreviated* form of module that only defines
options, but does not declare any. The structure of full NixOS modules
is shown in [Example: Structure of NixOS Modules](#ex-module-syntax).

::: {#ex-module-syntax .example}
**Example: Structure of NixOS Modules**
```nix
{ config, pkgs, ... }:

{
  imports =
    [ paths of other modules
    ];

  options = {
    option declarations
  };

  config = {
    option definitions
  };
}
```
:::

The meaning of each part is as follows.

-   The first line makes the current Nix expression a function. The variable
    `pkgs` contains Nixpkgs (by default, it takes the `nixpkgs` entry of
    `NIX_PATH`, see the [Nix manual](https://nixos.org/manual/nix/stable/#sec-common-env)
    for further details), while `config` contains the full system
    configuration. This line can be omitted if there is no reference to
    `pkgs` and `config` inside the module.

-   This `imports` list enumerates the paths to other NixOS modules that
    should be included in the evaluation of the system configuration. A
    default set of modules is defined in the file `modules/module-list.nix`.
    These don't need to be added in the import list.

-   The attribute `options` is a nested set of *option declarations*
    (described below).

-   The attribute `config` is a nested set of *option definitions* (also
    described below).

[Example: NixOS Module for the "locate" Service](#locate-example)
shows a module that handles the regular update of the "locate" database,
an index of all files in the file system. This module declares two
options that can be defined by other modules (typically the user's
`configuration.nix`): `services.locate.enable` (whether the database should
be updated) and `services.locate.interval` (when the update should be done).
It implements its functionality by defining two options declared by other
modules: `systemd.services` (the set of all systemd services) and
`systemd.timers` (the list of commands to be executed periodically by
`systemd`).

Care must be taken when writing systemd services using `Exec*` directives. By
default systemd performs substitution on `%<char>` specifiers in these
directives, expands environment variables from `$FOO` and `${FOO}`, splits
arguments on whitespace, and splits commands on `;`. All of these must be escaped
to avoid unexpected substitution or splitting when interpolating into an `Exec*`
directive, e.g. when using an `extraArgs` option to pass additional arguments to
the service. The functions `utils.escapeSystemdExecArg` and
`utils.escapeSystemdExecArgs` are provided for this, see [Example: Escaping in
Exec directives](#exec-escaping-example) for an example. When using these
functions system environment substitution should *not* be disabled explicitly.

::: {#locate-example .example}
**Example: NixOS Module for the "locate" Service**
```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.locate;
in {
  options.services.locate = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, NixOS will periodically update the database of
        files used by the locate command.
      '';
    };

    interval = mkOption {
      type = types.str;
      default = "02:15";
      example = "hourly";
      description = ''
        Update the locate database at this interval. Updates by
        default at 2:15 AM every day.

        The format is described in
        systemd.time(7).
      '';
    };

    # Other options omitted for documentation
  };

  config = {
    systemd.services.update-locatedb =
      { description = "Update Locate Database";
        path  = [ pkgs.su ];
        script =
          ''
            mkdir -m 0755 -p $(dirname ${toString cfg.output})
            exec updatedb \
              --localuser=${cfg.localuser} \
              ${optionalString (!cfg.includeStore) "--prunepaths='/nix/store'"} \
              --output=${toString cfg.output} ${concatStringsSep " " cfg.extraFlags}
          '';
      };

    systemd.timers.update-locatedb = mkIf cfg.enable
      { description = "Update timer for locate database";
        partOf      = [ "update-locatedb.service" ];
        wantedBy    = [ "timers.target" ];
        timerConfig.OnCalendar = cfg.interval;
      };
  };
}
```
:::

::: {#exec-escaping-example .example}
**Example: Escaping in Exec directives**
```nix
{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.echo;
  echoAll = pkgs.writeScript "echo-all" ''
    #! ${pkgs.runtimeShell}
    for s in "$@"; do
      printf '%s\n' "$s"
    done
  '';
  args = [ "a%Nything" "lang=\${LANG}" ";" "/bin/sh -c date" ];
in {
  systemd.services.echo =
    { description = "Echo to the journal";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.ExecStart = ''
        ${echoAll} ${utils.escapeSystemdExecArgs args}
      '';
    };
}
```
:::

```{=include=} sections
option-declarations.section.md
option-types.section.md
option-def.section.md
assertions.section.md
meta-attributes.section.md
importing-modules.section.md
replace-modules.section.md
freeform-modules.section.md
settings-options.section.md
```
