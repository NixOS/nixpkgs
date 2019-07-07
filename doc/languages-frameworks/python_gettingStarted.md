1. Global installation of Python in `configuration.nix` in `environment.systemPackages` with e.g. `(python36.withPackages(ps: with ps; [ numpy ]))`
2. Create a nix expression like `python.nix` with all dependencies for Python: 
```
with import <nixpkgs> {};

(python35.withPackages (ps: [ps.numpy ps.toolz])).env
´´´
3. Set up temporary Python environment with nix-shell: `$ nix-shell python.nix`
