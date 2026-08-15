# Dev environments {#dev-environments}

Create a `shell.nix` with the following:

```nix
# shell.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  pkgs = import nixpkgs { };
in
pkgs.mkShell {
  packages = [ pkgs.python3 ];
  shellHook = ''
    echo "Welcome in my nix shell"
  '';
}
```

run

```sh
nix-shell
```

This activates your `shell.nix` and you should see:

```sh
unpacking 'https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz' into the Git cache...
Welcome in your nix shell
```

python3 is available

```sh
$ python3 --version
```

To leave the shell

```bash
ctrl+D
```

:::{.note}
You should use [pinned nixpkgs](https://nix.dev/guides/recipes/dependency-management.html).
The example used `unstable` here for demonstration purposes only
:::

For further information check out [nix-shell](https://nix.dev/manual/nix/stable/command-ref/nix-shell)
