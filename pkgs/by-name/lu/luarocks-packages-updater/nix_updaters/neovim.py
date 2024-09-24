#!/usr/bin/env python3

import nix_luarocks_updater
import inspect

import os
from pathlib import Path

# --
# import luarocks.updater

INPUT_FILENAME = "pkgs/applications/editors/vim/plugins/neovim-luarocks-plugins.csv"
# PKG_LIST = "maintainers/scripts/luarocks-packages.csv"
GENERATED_NIXFILE = "pkgs/applications/editors/neovim/generated-plugins.nix"

ROOT = Path(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))).parent.parent  # type: ignore

HEADER = """/* {GENERATED_NIXFILE} is an auto-generated file -- DO NOT EDIT!
Regenerate it with: nix run nixpkgs#neovim-plugins-updater
You can customize the generated packages in
pkgs/applications/editors/vim/plugins/overrides.nix
*/
{{ stdenv, lib, fetchurl, fetchgit, callPackage, buildNeovimPlugin, ... }}:
final: prev:
{{

""".format(
    GENERATED_NIXFILE=GENERATED_NIXFILE
)


def main():
    editor = nix_luarocks_updater.LuaEditor(
        "neovim",
        ROOT,
        "",
        default_in=INPUT_FILENAME,
        default_out=GENERATED_NIXFILE,
    )
    editor.header = HEADER

    def generate_neovim_nix_pkg(plug: nix_luarocks_updater.LuaPlugin) -> str:
        nix_expr = """
            let
                luaPkg = {luaPkg}
            in
                buildNeovimPlugin {{ rawLuaDrv = luaPkg; }};

        """.format(
                # TODO would be better to have a .to_nix() member
            luaPkg = nix_luarocks_updater.LuaEditor.generate_pkg_nix(plug)[1]
            )
        return (plug, nix_expr)

    editor.generate_pkg_nix = generate_neovim_nix_pkg


    editor.run()


if __name__ == "__main__":
    main()

