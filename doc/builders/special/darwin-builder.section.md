# darwin.linux-builder {#sec-darwin-builder}

`darwin.linux-builder` provides a way to bootstrap a Linux builder on a macOS machine.

This requires macOS version 12.4 or later.

The builder runs on host port `31022` by default.
You can change it by overriding `virtualisation.darwin-builder.hostPort`.
See the [example](#sec-darwin-builder-example-flake).

You will also need to be a trusted user for your Nix installation.  In other
words, your `/etc/nix/nix.conf` should have something like:

```
extra-trusted-users = <your username goes here>
```

To launch the builder, run the following flake:

```ShellSession
$ nix run nixpkgs#darwin.linux-builder
```

The script will first prompt you to enter your host `sudo` password:

```
+ sudo --reset-timestamp /nix/store/…-install-credentials.sh ./keys
Password:
```

… to install a private key used to `ssh` into the build server.

After that, the virtual machine will be launched and you will be automatically logged
in as the `builder` user:

```
<<< Welcome to NixOS 22.11.20220901.1bd8d11 (aarch64) - ttyAMA0 >>>

Run 'nixos-help' for the NixOS manual.

nixos login: builder (automatic login)


[builder@nixos:~]$
```

> Note: When you need to stop the VM, run `shutdown now` as the `builder` user.

Because the builder is not running by default on port 22, you will also need to create a new file at `/etc/ssh/ssh_config.d/100-linux-builder.conf`:

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

Your host user should belong to the group `nixbld`:

```ShellSession
$ sudo dseditgroup -o edit -a $(whoami) -t user nixbld
```

To test that the builder is working run (you'll have to run it as sudo):

```ShellSession
$ sudo nix store ping --store ssh-ng://builder@linux-builder
```

## Delegating builds to the remote builder {#delegating-builds}

To delegate builds to the remote builder, add the following options to your
`nix.conf` file:

```conf
# - Replace ${ARCH} with either aarch64 or x86_64 to match your host machine
# - Replace ${MAX_JOBS} with the maximum number of builds (pick 4 if you're not sure)
builders = ssh-ng://builder@linux-builder ${ARCH}-linux /etc/nix/builder_ed25519 ${MAX_JOBS} - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=

# Not strictly necessary, but this will reduce your disk utilization
builders-use-substitutes = true
```

… and you are ready to use it.

In order to build a flake with the builder, you can
use something like:



```ShellSession
$ nix build --system x86_64-linux --max-jobs 0 .#YOUR_PACKAGE --json
```

… we attach the `--json` flag in order to retrieve the output.
Which can be used to copy the result from the builder to your host's nix store.

```ShellSession
nix copy --from ssh-ng://builder@linux-builder OUTPUT
```

## Example flake usage {#sec-darwin-builder-example-flake}

```
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs, ... }@inputs:
  let

    inherit (darwin.lib) darwinSystem;
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages."${system}";
    linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] system;

    darwin-builder = nixpkgs.lib.nixosSystem {
      system = linuxSystem;
      modules = [
        "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
        { virtualisation.host.pkgs = pkgs; }
      ];
    };
  in {

    darwinConfigurations = {
      machine1 = darwinSystem {
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

## Reconfiguring the builder {#sec-darwin-builder-reconfiguring}

Initially you should not change the builder configuration else you will not be
able to use the binary cache. However, after you have the builder running locally
you may use it to build a modified builder with additional storage or memory.

To do this, you just need to set the `virtualisation.darwin-builder.*` parameters as
in the example below and rebuild.

```
    darwin-builder = nixpkgs.lib.nixosSystem {
      system = linuxSystem;
      modules = [
        "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
        {
          virtualisation.host.pkgs = pkgs;
          virtualisation.darwin-builder.diskSize = 5120;
          virtualisation.darwin-builder.memorySize = 1024;
          virtualisation.darwin-builder.hostPort = 33022;
          virtualisation.darwin-builder.workingDirectory = "/var/lib/darwin-builder";
        }
      ];
```

You may make any other changes to your VM in this attribute set. For example,
you could enable Docker or X11 forwarding to your Darwin host.

