import argparse
import os
import time
from pathlib import Path

import ptpython.repl

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

    def __init__(self, envvar, required=False, default=None, nargs=None, type=None, **kwargs):  # type: ignore
        type_fn = type if type else lambda x: x
        if not default and envvar:
            if envvar in os.environ:
                if nargs is not None and (nargs.isdigit() or nargs in ["*", "+"]):
                    default = list(map(type_fn, os.environ[envvar].split()))
                else:
                    default = type_fn(os.environ[envvar])
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
        type=int,
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
        "--rebuild-cmd",
        action=EnvDefault,
        envvar="rebuildCmd",
        help="When running the driver interactively, this command builds a new version of the driver when rebuild() is called",
        type=str,
    )
    arg_parser.add_argument(
        "--rebuild-exe",
        action=EnvDefault,
        envvar="rebuildExe",
        help="When running the driver interactively, rebuild() will execute this to find out new driver information. It should be behind a symlink.",
        type=str,
    )
    arg_parser.add_argument(
        "--internal-print-update-driver-info-and-exit",
        action="store_true",
        # For internal use. Don't print help text.
        help=argparse.SUPPRESS,
    )
    arg_parser.add_argument(
        "testscript",
        action=EnvDefault,
        envvar="testScript",
        help="the test script to run",
        type=Path,
    )

    args = arg_parser.parse_args()

    # print the info needed to update another Driver
    # TODO: properly escape these arguments
    if args.internal_print_update_driver_info_and_exit:
        print(*args.start_scripts)
        print(*args.vlans)
        print(args.testscript)
        print(args.output_directory)
        exit(0)

    output_directory = args.output_directory.resolve()
    logger = CompositeLogger([TerminalLogger()])

    if "LOGFILE" in os.environ.keys():
        logger.add_logger(XMLLogger(os.environ["LOGFILE"]))

    if args.junit_xml:
        logger.add_logger(JunitXMLLogger(output_directory / args.junit_xml))

    if not args.keep_vm_state:
        logger.info("Machine state will be reset. To keep it, pass --keep-vm-state")

    if args.rebuild_cmd and not args.interactive:
        logger.warning("--rebuild-cmd is not useful outside of interactive mode")
    if args.rebuild_exe and not args.interactive:
        logger.warning("--rebuild-exe is not useful outside of interactive mode")

    with Driver(
        args.start_scripts,
        args.vlans,
        args.testscript.read_text(),
        output_directory,
        logger,
        args.keep_vm_state,
        args.global_timeout,
        args.rebuild_cmd,
        args.rebuild_exe,
    ) as driver:
        if args.interactive:
            history_dir = os.getcwd()
            history_path = os.path.join(history_dir, ".nixos-test-history")
            ptpython.repl.embed(
                driver.test_symbols(),
                {},
                history_filename=history_path,
            )
        else:
            tic = time.time()
            driver.run_tests()
            toc = time.time()
            logger.info(f"test script finished in {(toc-tic):.2f}s")


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
