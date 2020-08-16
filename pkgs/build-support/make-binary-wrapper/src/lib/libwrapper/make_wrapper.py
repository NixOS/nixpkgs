import argparse
import textwrap
from typing import Dict

import libwrapper.compile_wrapper


EPILOG = textwrap.dedent('''\
This program creates a binary wrapper. The arguments given are
serialized to JSON. A binary wrapper is created and the JSON is
embedded into it.

For debugging purposes it is possible to view the embedded JSON:

    NIX_DEBUG_PYTHON=1 my-wrapped-executable

''')


def parse_args() -> Dict:

    parser = argparse.ArgumentParser(
        description="Create a binary wrapper.",
        epilog=EPILOG,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument("original", type=str,
        help="Path of executable to wrap",
    )
    parser.add_argument("wrapper", type=str,
        help="Path of wrapper to create",
    )
    # parser.add_argument(
    #     "--argv", nargs=1, type=str, metavar="NAME", default,
    #     help="Set name of executed process. Not used."
    # )
    parser.add_argument(
        "--set", nargs=2, type=str, metavar=("VAR", "VAL"), action="append", default=[],
        help="Set environment variable to value",
    )
    parser.add_argument(
        "--set-default", nargs=2, type=str, metavar=("VAR", "VAL"), action="append", default=[],
        help="Set environment variable to value, if not yet set in environment",
    )
    parser.add_argument(
        "--unset", nargs=1, type=str, metavar="VAR", action="append", default=[],
        help="Unset variable from the environment"
    )
    parser.add_argument(
        "--run", nargs=1, type=str, metavar="COMMAND", action="append",
        help="Run command before the executable"
    )
    parser.add_argument(
        "--add-flags", dest="flags", nargs=1, type=str, metavar="FLAGS", action="append", default=[],
        help="Add flags to invocation of process"
    )
    parser.add_argument(
        "--prefix", nargs=3, type=str, metavar=("ENV", "SEP", "VAL"), action="append", default=[],
        help="Prefix environment variable ENV with value VAL, separated by separator SEP"
    )
    parser.add_argument(
        "--suffix", nargs=3, type=str, metavar=("ENV", "SEP", "VAL"), action="append", default=[],
        help="Suffix environment variable ENV with value VAL, separated by separator SEP"
    )
    # TODO: Fix help message because we cannot use metavar with nargs="+".
    # Note these hardly used in Nixpkgs and may as well be dropped.
    # parser.add_argument(
    #     "--prefix-each", nargs="+", type=str, action="append", 
    #     help="Prefix environment variable ENV with values VALS, separated by separator SEP."
    # )
    # parser.add_argument(
    #     "--suffix-each", nargs="+", type=str, action="append", 
    #     help="Suffix environment variable ENV with values VALS, separated by separator SEP."
    # )
    # parser.add_argument(
    #     "--prefix-contents", nargs="+", type=str, action="append", 
    #     help="Prefix environment variable ENV with values read from FILES, separated by separator SEP."
    # )
    # parser.add_argument(
    #     "--suffix-contents", nargs="+", type=str, action="append", 
    #     help="Suffix environment variable ENV with values read from FILES, separated by separator SEP."
    # )
    return vars(parser.parse_args())


def convert_args(args: Dict) -> Dict:
    """Convert arguments to the JSON structure expected by the Nim wrapper."""
    output = {}

    # Would not need this if the Environment members were  part of Wrapper.
    output["original"] = args["original"]
    output["wrapper"] = args["wrapper"]
    output["run"] = args["run"]
    output["flags"] = [item[0] for item in args["flags"]]

    output["environment"] = {}
    for key, value in args.items():
        if key == "set":
            output["environment"][key] = [dict(zip(["variable", "value"], item)) for item in value]
        if key == "set_default":
            output["environment"][key] = [dict(zip(["variable", "value"], item)) for item in value]
        if key == "unset":
            output["environment"][key] = [dict(zip(["variable"], item)) for item in value]
        if key == "prefix":
            output["environment"][key] = [dict(zip(["variable", "value", "separator"], item)) for item in value]
        if key == "suffix":
            output["environment"][key] = [dict(zip(["variable", "value", "separator"], item)) for item in value]

    return output


def main():
    args = parse_args()
    args = convert_args(args)
    libwrapper.compile_wrapper.compile_wrapper(args)
    

if __name__ == "__main__":
    main()