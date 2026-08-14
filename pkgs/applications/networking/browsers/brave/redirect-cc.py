#!/usr/bin/env python3
"""Brave chromium_src source remapper for Chromium's cc_wrapper.

Mirrors brave/tools/redirect_cc: when compiling foo.cc, if
brave/chromium_src/foo.cc exists, compile that instead (it #includes <foo.cc>
after defining BRAVE_* macros).
"""
from __future__ import annotations

import os
import sys


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("redirect-cc: missing compiler", file=sys.stderr)
        return 1

    compiler = argv[0]
    args = argv[1:]

    brave_chromium_src = None
    chromium_src_prefix = None
    for arg in args:
        if arg.startswith("-iquote") and arg.endswith("brave/chromium_src"):
            brave_chromium_src = arg[len("-iquote") :]
            chromium_src_prefix = brave_chromium_src[: -len("brave/chromium_src")]
            break

    if chromium_src_prefix is None:
        print("redirect-cc: can't find chromium src dir (-iquote…/brave/chromium_src)", file=sys.stderr)
        return 1

    out_args: list[str] = []
    i = 0
    while i < len(args):
        arg = args[i]
        if arg in ("-c", "/c") and i + 1 < len(args):
            path_cc = args[i + 1]
            # Another compiler flag, not a path (asm toolchain quirk).
            if path_cc and path_cc[0] == arg[0]:
                out_args.append(arg)
                i += 1
                continue

            rel = None
            if path_cc.startswith(chromium_src_prefix):
                rel = path_cc[len(chromium_src_prefix) :]
            else:
                parts = path_cc.split(os.sep)
                if parts and parts[0] == "gen":
                    rel = path_cc[len("gen") + 1 :]
                elif len(parts) > 1 and parts[1] == "gen":
                    rel = os.sep.join(parts[2:])

            if rel:
                brave_path = os.path.join(brave_chromium_src, rel)
                if os.path.exists(brave_path):
                    out_args.extend([arg, brave_path])
                    i += 2
                    continue

            out_args.append(arg)
            i += 1
            continue

        out_args.append(arg)
        i += 1

    os.execvp(compiler, [compiler, *out_args])
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
