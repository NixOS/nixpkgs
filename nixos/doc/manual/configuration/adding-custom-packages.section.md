# Adding Custom Packages {#sec-custom-packages}

It's possible that a package you need is not available in NixOS. In that
case, you can do two things. First, you can clone the Nixpkgs
repository, add the package to your clone, and (optionally) submit a
patch or pull request to have it accepted into the main Nixpkgs repository.
This is described in detail in the [Nixpkgs manual](https://nixos.org/nixpkgs/manual).
In short, you clone Nixpkgs:

```ShellSession
$ git clone https://github.com/NixOS/nixpkgs
$ cd nixpkgs
```

Then you write and test the package as described in the Nixpkgs manual.
Finally, you add it to [](#opt-environment.systemPackages), e.g.

```nix
environment.systemPackages = [ pkgs.my-package ];
```

and you run `nixos-rebuild`, specifying your own Nixpkgs tree:

```ShellSession
# nixos-rebuild switch -I nixpkgs=/path/to/my/nixpkgs
```

The second possibility is to add the package outside of the Nixpkgs
tree. For instance, here is how you specify a build of the
[GNU Hello](https://www.gnu.org/software/hello/) package directly in
`configuration.nix`:

```nix
environment.systemPackages =
  let
    my-hello = with pkgs; stdenv.mkDerivation rec {
      name = "hello-2.8";
      src = fetchurl {
        url = "mirror://gnu/hello/${name}.tar.gz";
        sha256 = "0wqd8sjmxfskrflaxywc7gqw7sfawrfvdxd9skxawzfgyy0pzdz6";
      };
    };
  in
  [ my-hello ];
```

Of course, you can also move the definition of `my-hello` into a
separate Nix expression, e.g.

```nix
environment.systemPackages = [ (import ./my-hello.nix) ];
```

where `my-hello.nix` contains:

```nix
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "hello-2.8";
  src = fetchurl {
    url = "mirror://gnu/hello/${name}.tar.gz";
    sha256 = "0wqd8sjmxfskrflaxywc7gqw7sfawrfvdxd9skxawzfgyy0pzdz6";
  };
}
```

This allows testing the package easily:

```ShellSession
$ nix-build my-hello.nix
$ ./result/bin/hello
Hello, world!
```
