import argparse
import os
import time
from pathlib import Path

import ptpython.ipython

from test_driver.debug import Debug, DebugAbstract, DebugNop
from test_driver.driver import Driver
from test_driver.logger import (
    CompositeLogger,
    JunitXMLLogger,
    TerminalLogger,
    XMLLogger,
)


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
        super().__init__(default=default, required=required, nargs=nargs, **kwargs)

    def __call__(self, parser, namespace, values, option_string=None):  # type: ignore
        setattr(namespace, self.dest, values)


def writeable_dir(arg: str) -> Path:
    """Raises an ArgumentTypeError if the given argument isn't a writeable directory
    Note: We want to fail as early as possible if a directory isn't writeable,
    since an executed nixos-test could fail (very late) because of the test-driver
    writing in a directory without proper permissions.
    """
    path = Path(arg)
    if not path.is_dir():
        raise argparse.ArgumentTypeError(f"{path} is not a directory")
    if not os.access(path, os.W_OK):
        raise argparse.ArgumentTypeError(f"{path} is not a writeable directory")
    return path


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
        action=argparse.BooleanOptionalAction,
    )
    arg_parser.add_argument(
        "--debug-hook-attach",
        help="Enable interactive debugging breakpoints for sandboxed runs",
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
        "--global-timeout",
        type=int,
        metavar="GLOBAL_TIMEOUT",
        action=EnvDefault,
        envvar="globalTimeout",
        help="Timeout in seconds for the whole test",
    )
    arg_parser.add_argument(
        "-o",
        "--output_directory",
        help="""The path to the directory where outputs copied from the VM will be placed.
                By e.g. Machine.copy_from_vm or Machine.screenshot""",
        default=Path.cwd(),
        type=writeable_dir,
    )
    arg_parser.add_argument(
        "--junit-xml",
        help="Enable JunitXML report generation to the given path",
        type=Path,
    )
    arg_parser.add_argument(
        "testscript",
        action=EnvDefault,
        envvar="testScript",
        help="the test script to run",
        type=Path,
    )
    arg_parser.add_argument(
        "--dump-vsocks",
        help="indicates that the interactive SSH backdoor is active and dumps information about it on start",
        type=int,
    )

    args = arg_parser.parse_args()

    output_directory = args.output_directory.resolve()
    logger = CompositeLogger([TerminalLogger()])

    if "LOGFILE" in os.environ.keys():
        logger.add_logger(XMLLogger(os.environ["LOGFILE"]))

    if args.junit_xml:
        logger.add_logger(JunitXMLLogger(output_directory / args.junit_xml))

    if not args.keep_vm_state:
        logger.info("Machine state will be reset. To keep it, pass --keep-vm-state")

    debugger: DebugAbstract = DebugNop()
    if args.debug_hook_attach is not None:
        debugger = Debug(logger, args.debug_hook_attach)

    with Driver(
        args.start_scripts,
        args.vlans,
        args.testscript.read_text(),
        output_directory,
        logger,
        args.keep_vm_state,
        args.global_timeout,
        debug=debugger,
    ) as driver:
        if offset := args.dump_vsocks:
            driver.dump_machine_ssh(offset)
        if args.interactive:
            history_dir = os.getcwd()
            history_path = os.path.join(history_dir, ".nixos-test-history")
            ptpython.ipython.embed(
                user_ns=driver.test_symbols(),
                history_filename=history_path,
            )  # type:ignore
        else:
            tic = time.time()
            driver.run_tests()
            toc = time.time()
            logger.info(f"test script finished in {(toc - tic):.2f}s")


def generate_driver_symbols() -> None:
    """
    This generates a file with symbols of the test-driver code that can be used
    in user's test scripts. That list is then used by pyflakes to lint those
    scripts.
    """
    d = Driver([], [], "", Path(), CompositeLogger([]))
    test_symbols = d.test_symbols()
    with open("driver-symbols", "w") as fp:
        fp.write(",".join(test_symbols.keys()))
