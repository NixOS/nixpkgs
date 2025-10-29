# darwin.linux-builder {#sec-darwin-builder}

:::{.warning}
By default, `darwin.linux-builder` uses a publicly-known private SSH **host key** (this is different from the SSH key used by the user that connects to the builder).

Given the intended use case for it (a Linux builder that runs **on the same machine**), this shouldn't be an issue.
However, if you plan to deviate from this use case in any way (e.g. by exposing this builder to remote machines), you should understand the security implications of doing so and take any appropriate measures.
:::

`darwin.linux-builder` provides a way to bootstrap a Linux remote builder on a macOS machine.

This requires macOS version 12.4 or later.

The remote builder runs on host port 31022 by default.
You can change it by overriding `virtualisation.darwin-builder.hostPort`.
See the [example](#sec-darwin-builder-example-flake).

You will also need to be a trusted user for your Nix installation.  In other
words, your `/etc/nix/nix.conf` should have something like:

```
extra-trusted-users = <your username goes here>
```

To launch the remote builder, run the following flake:

```ShellSession
$ nix run nixpkgs#darwin.linux-builder
```

That will prompt you to enter your `sudo` password:

```
+ sudo --reset-timestamp /nix/store/…-install-credentials.sh ./keys
Password:
```

… so that it can install a private key used to `ssh` into the build server.
After that the script will launch the virtual machine and automatically log you
in as the `builder` user:

```
<<< Welcome to NixOS 22.11.20220901.1bd8d11 (aarch64) - ttyAMA0 >>>

Run 'nixos-help' for the NixOS manual.

nixos login: builder (automatic login)


[builder@nixos:~]$
```

> Note: When you need to stop the VM, run `shutdown now` as the `builder` user.

To delegate builds to the remote builder, add the following options to your
`nix.conf` file:

```
# - Replace ${ARCH} with either aarch64 or x86_64 to match your host machine
# - Replace ${MAX_JOBS} with the maximum number of builds (pick 4 if you're not sure)
builders = ssh-ng://builder@linux-builder ${ARCH}-linux /etc/nix/builder_ed25519 ${MAX_JOBS} - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=

# Not strictly necessary, but this will reduce your disk utilization
builders-use-substitutes = true
```

To allow Nix to connect to a remote builder not running on port 22, you will also need to create a new file at `/etc/ssh/ssh_config.d/100-linux-builder.conf`:

```
Host linux-builder
  Hostname localhost
  HostKeyAlias linux-builder
  Port 31022
```

… and then restart your Nix daemon to apply the change:

```ShellSession
$ sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

## Example flake usage {#sec-darwin-builder-example-flake}

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      ...
    }@inputs:
    let

      inherit (darwin.lib) darwinSystem;
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages."${system}";
      linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] system;

      darwin-builder = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [
          "${nixpkgs}/nixos/modules/profiles/nix-builder-vm.nix"
          {
            virtualisation = {
              host.pkgs = pkgs;
              darwin-builder.workingDirectory = "/var/lib/darwin-builder";
              darwin-builder.hostPort = 22;
            };
          }
        ];
      };
    in
    {

      darwinConfigurations = {
        machine1 = darwinSystem {
          inherit system;
          modules = [
            {
              nix.distributedBuilds = true;
              nix.buildMachines = [
                {
                  hostName = "localhost";
                  sshUser = "builder";
                  sshKey = "/etc/nix/builder_ed25519";
                  system = linuxSystem;
                  maxJobs = 4;
                  supportedFeatures = [
                    "kvm"
                    "benchmark"
                    "big-parallel"
                  ];
                }
              ];

              launchd.daemons.darwin-builder = {
                command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
                serviceConfig = {
                  KeepAlive = true;
                  RunAtLoad = true;
                  StandardOutPath = "/var/log/darwin-builder.log";
                  StandardErrorPath = "/var/log/darwin-builder.log";
                };
              };
            }
          ];
        };
      };

    };
}
```

## Reconfiguring the remote builder {#sec-darwin-builder-reconfiguring}

Initially you should not change the remote builder configuration else you will not be
able to use the binary cache. However, after you have the remote builder running locally
you may use it to build a modified remote builder with additional storage or memory.

To do this, you just need to set the `virtualisation.darwin-builder.*` parameters as
in the example below and rebuild.

```nix
{
  darwin-builder = nixpkgs.lib.nixosSystem {
    system = linuxSystem;
    modules = [
      "${nixpkgs}/nixos/modules/profiles/nix-builder-vm.nix"
      {
        virtualisation.host.pkgs = pkgs;
        virtualisation.darwin-builder.diskSize = 5120;
        virtualisation.darwin-builder.memorySize = 1024;
        virtualisation.darwin-builder.hostPort = 33022;
        virtualisation.darwin-builder.workingDirectory = "/var/lib/darwin-builder";
      }
    ];
  };
}
```

You may make any other changes to your VM in this attribute set. For example,
you could enable Docker or X11 forwarding to your Darwin host.

## Troubleshooting the generated configuration {#sec-darwin-builder-troubleshoot}

The `linux-builder` package exposes the attributes `nixosConfig` and `nixosOptions` that allow you to inspect the generated NixOS configuration in the `nix repl`. For example:

```
$ nix repl --file ~/src/nixpkgs --argstr system aarch64-darwin

nix-repl> darwin.linux-builder.nixosConfig.nix.package
«derivation /nix/store/...-nix-2.17.0.drv»

nix-repl> :p darwin.linux-builder.nixosOptions.virtualisation.memorySize.definitionsWithLocations
[ { file = "/home/user/src/nixpkgs/nixos/modules/profiles/nix-builder-vm.nix"; value = 3072; } ]

```
