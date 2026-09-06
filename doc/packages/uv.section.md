# uv {#sec-uv}

`uv` is an extremely fast Python package installer and resolver, written in Rust.
It manages project dependencies and environments, with support for lockfiles, workspaces, and more.

Due to `uv` being unaware that it is running on a NixOS system, by default, it will fetch dynamically-linked Python executables that will fail to run, as NixOS cannot run executables intended for generic Linux environments out of the box.
To learn more on this, please visit
https://nix.dev/guides/faq.html#how-to-run-non-nix-executables

There are two ways to mitigate this:

1. Provide `uv` with a statically-linked Python executable (ideally from `nixpkgs`) via the [`UV_PYTHON` environment variable](https://docs.astral.sh/uv/reference/environment/#uv_python). Alternatively, the `--python` flag can also be used, but this is easy to forget. It is also helpful to forbid `uv` from downloading any Python binaries via the [`UV_PYTHON_DOWNLOADS` environment variable](https://docs.astral.sh/uv/reference/environment/#uv_python_downloads) by setting it to `never`.
These variables can be set in `shell.nix` and `.env` files, which can be redistributed with the project to ensure other NixOS machines can execute the project.

2. Add `programs.nix-ld.enable = true` to your NixOS config. While functional, the previous option is to be preferred, as this is the "works on my machine" option, because redistributing Python projects that use `uv` to another NixOS machine that does not have `nix-ld` enabled will cause the same errors to occur.

Additionally, there is the issue of modules from PyPI vendoring dynamically-linked libraries, such as `numpy`, which will also fail to work.
This topic is not local to `uv`, but is deserving of documentation nonetheless.
Setting `LD_LIBRARY_PATH` should be the solution of choice here. Either:

1. Use `lib.makeLibraryPath` to set `LD_LIBRARY_PATH` from a `shell.nix`, e.g. `LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.openssl pkgs.zlib pkgs.curl ]`
2. (If you have already enabled `nix-ld`) set `LD_LIBRARY_PATH` to `NIX_LD_LIBRARY_PATH`. Be aware this is not a silver bullet solution, as this simply provides a list of commonly used libraries, as is shown in `nixos/modules/programs/nix-ld.nix`.
