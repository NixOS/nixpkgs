from pathlib import Path
import argparse
import ptpython.repl
import os
import time

from test_driver.logger import rootlog
from test_driver.driver import Driver


class EnvDefault(argparse.Action):
    """An argpars Action that takes values from the specified
    environment variable as the flags default value.
    """

    def __init__(self, envvar, required=False, default=None, nargs=None, **kwargs):  # type: ignore
        if not default and envvar:
            if envvar in os.environ:
                if nargs is not None and (nargs.isdigit() or nargs in ["*", "+"]):
                    default = os.environ[envvar].split()
                else:
                    default = os.environ[envvar]
                kwargs["help"] = (
                    kwargs["help"] + f" (default from environment: {default})"
                )
        if required and default:
            required = False
        super(EnvDefault, self).__init__(
            default=default, required=required, nargs=nargs, **kwargs
        )

    def __call__(self, parser, namespace, values, option_string=None):  # type: ignore
        setattr(namespace, self.dest, values)


def main() -> None:
    arg_parser = argparse.ArgumentParser(prog="nixos-test-driver")
    arg_parser.add_argument(
        "-K",
        "--keep-vm-state",
        help="re-use a VM state coming from a previous run",
        action="store_true",
    )
    arg_parser.add_argument(
        "-I",
        "--interactive",
        help="drop into a python repl and run the tests interactively",
        action="store_true",
    )
    arg_parser.add_argument(
        "--start-scripts",
        metavar="START-SCRIPT",
        action=EnvDefault,
        envvar="startScripts",
        nargs="*",
        help="start scripts for participating virtual machines",
    )
    arg_parser.add_argument(
        "--vlans",
        metavar="VLAN",
        action=EnvDefault,
        envvar="vlans",
        nargs="*",
        help="vlans to span by the driver",
    )
    arg_parser.add_argument(
        "testscript",
        action=EnvDefault,
        envvar="testScript",
        help="the test script to run",
        type=Path,
    )

    args = arg_parser.parse_args()

    if not args.keep_vm_state:
        rootlog.info("Machine state will be reset. To keep it, pass --keep-vm-state")

    with Driver(
        args.start_scripts, args.vlans, args.testscript.read_text(), args.keep_vm_state
    ) as driver:
        if args.interactive:
            ptpython.repl.embed(driver.test_symbols(), {})
        else:
            tic = time.time()
            driver.run_tests()
            toc = time.time()
            rootlog.info(f"test script finished in {(toc-tic):.2f}s")


def generate_driver_symbols() -> None:
    """
    This generates a file with symbols of the test-driver code that can be used
    in user's test scripts. That list is then used by pyflakes to lint those
    scripts.
    """
    d = Driver([], [], "")
    test_symbols = d.test_symbols()
    with open("driver-symbols", "w") as fp:
        fp.write(",".join(test_symbols.keys()))
