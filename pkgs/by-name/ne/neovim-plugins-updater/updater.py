#!/usr/bin/env python3

import updater
import inspect

import os
from pathlib import Path

# --
# import luarocks.updater

INPUT_FILENAME = "pkgs/applications/editors/vim/plugins/neovim-luarocks-plugins.csv"
# PKG_LIST = "maintainers/scripts/luarocks-packages.csv"
GENERATED_NIXFILE = "pkgs/applications/editors/neovim/generated-plugins.nix"

ROOT = Path(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))).parent.parent  # type: ignore


def main():
    editor = LuaEditor(
        "neovim",
        ROOT,
        "",
        default_in=INPUT_FILENAME,
        default_out=GENERATED_NIXFILE,
    )

    editor.run()


if __name__ == "__main__":
    main()

