# darwin.builder {#sec-darwin-builder}

`darwin.builder` provides a way to bootstrap a Linux builder on a macOS machine.

This requires macOS version 12.4 or later.

This also requires that port 22 on your machine is free (since Nix does not
permit specifying a non-default SSH port for builders).

You will also need to be a trusted user for your Nix installation.  In other
words, your `/etc/nix/nix.conf` should have something like:

```
extra-trusted-users = <your username goes here>
```

To launch the builder, run the following flake:

```ShellSession
$ nix run nixpkgs#darwin.builder
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
builders = ssh-ng://builder@localhost ${ARCH}-linux /etc/nix/builder_ed25519 ${MAX_JOBS} - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=

# Not strictly necessary, but this will reduce your disk utilization
builders-use-substitutes = true
```

… and then restart your Nix daemon to apply the change:

```ShellSession
$ sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

## Example flake usage

```
{
  inputs = {
    nixpkgs.url = "path:/Users/geraint.ballinger/Documents/personal/nixpkgs";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, darwin, nixpkgs, ... }@inputs:
  let

    inherit (darwin.lib) darwinSystem;
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages."${system}";
    linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] system;

    darwin-builder = nixpkgs.nixosSystem {
      system = linuxSystem;
      modules = [
        "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
        { virtualisation.host.pkgs = pkgs; }
      ];
    };
  in {

    darwinConfigurations = rec {
      machine1 = darwinSystem rec {
        inherit system;
        modules = [
          {
            nix.distributedBuilds = true;
            nix.buildMachines = [{
              hostName = "ssh://builder@localhost";
              system = linuxSystem;
              maxJobs = 4;
              supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
            }];

            launchd.daemons.darwin-builder = {
              command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
              path = [ "/usr/bin" pkgs.coreutils pkgs.nix ];
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

## Reconfiguring the builder

Initially you should not change the builder configuration else you will not be
able to use the binary cache. However, after you have the builder running locally
you may use it to build a modified builder with additional storage or memory.
To do this, import the `macos-builder` module into your nix configuration and
edit the `virtualisation.darwin-builder.*` parameters as desired and rebuild.

