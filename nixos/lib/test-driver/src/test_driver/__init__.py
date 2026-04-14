import argparse
import os
import sys
import time
import warnings
from pathlib import Path

import ptpython.ipython

from test_driver.debug import Debug, DebugAbstract, DebugNop
from test_driver.driver import Driver, DriverConfiguration, load_driver_configuration
from test_driver.logger import (
    CompositeLogger,
    JunitXMLLogger,
    LogLevel,
    TerminalLogger,
    XMLLogger,
)


class EnvDefault(argparse.Action):
    """An argparse Action that takes values from the specified
    environment variable as the flags default value.
    """

    def __init__(self, envvar, required=False, default=None, nargs=None, **kwargs):
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

    def __call__(self, parser, namespace, values, option_string=None):
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
        "-c",
        "--config",
        help="the test driver configuration file",
        type=Path,
        required=True,
    )
    arg_parser.add_argument(
        "--keep-vm-state",
        help=argparse.SUPPRESS,
        dest="keep_machine_state",
        action="store_true",
    )
    arg_parser.add_argument(
        "-K",
        "--keep-machine-state",
        help="re-use a machine state coming from a previous run",
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
        "-o",
        "--output_directory",
        help="""The path to the directory where outputs copied from the machine will be placed.
                By e.g. NspawnMachine.copy_from_machine or QemuMachine.screenshot""",
        default=Path.cwd(),
        type=writeable_dir,
    )
    arg_parser.add_argument(
        "--junit-xml",
        help="Enable JunitXML report generation to the given path",
        type=Path,
    )
    log_level_map = {level.name.lower(): level for level in LogLevel}
    arg_parser.add_argument(
        "--log-level",
        metavar="LOG_LEVEL",
        action=EnvDefault,
        envvar="logLevel",
        choices=log_level_map,
        help="Set the log level",
    )

    args = arg_parser.parse_args()

    if "--keep-vm-state" in sys.argv:
        warnings.warn(
            "The flag '--keep-vm-state' is deprecated. Use '--keep-machine-state' instead.",
            DeprecationWarning,
        )

    output_directory = args.output_directory.resolve()
    logger = CompositeLogger([TerminalLogger()])

    if "LOGFILE" in os.environ.keys():
        logger.add_logger(XMLLogger(os.environ["LOGFILE"]))

    if args.junit_xml:
        logger.add_logger(JunitXMLLogger(output_directory / args.junit_xml))

    if args.log_level:
        logger.set_log_level(log_level_map[args.log_level])

    if not args.keep_machine_state:
        logger.info(
            "Machine state will be reset. To keep it, pass --keep-machine-state"
        )

    debugger: DebugAbstract = DebugNop()
    if args.debug_hook_attach is not None:
        debugger = Debug(logger, args.debug_hook_attach)

    with Driver(
        config=load_driver_configuration(args.config),
        out_dir=output_directory,
        logger=logger,
        keep_machine_state=args.keep_machine_state,
        debug=debugger,
    ) as driver:
        if driver.config.enable_ssh_backdoor:
            driver.dump_machine_ssh()
        if args.interactive:
            history_dir = os.getcwd()
            history_path = os.path.join(history_dir, ".nixos-test-history")
            ptpython.ipython.embed(
                user_ns=driver.test_symbols(),
                history_filename=history_path,
            )
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
    d = Driver(
        config=DriverConfiguration(
            vms=dict(),
            containers=dict(),
            vlans=[],
            global_timeout=0,
            enable_ssh_backdoor=False,
            test_script=Path("testScriptWithTypes"),
        ),
        out_dir=Path(),
        logger=CompositeLogger([]),
    )
    test_symbols = d.test_symbols()
    with open("driver-symbols", "w") as fp:
        fp.write(",".join(test_symbols.keys()))
