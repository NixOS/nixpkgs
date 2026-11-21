"""Command line entry point."""

import argparse
import asyncio
import pathlib
import sys

from test_driver.errors import MachineError, RequestedAssertionFailed
from test_driver.logger import (
    AbstractLogger,
    CompositeLogger,
    LogLevel,
    TerminalLogger,
)

from image_test_driver import config as config_module
from image_test_driver import testscript
from image_test_driver.driver import Driver


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="run a virtual machine image test")
    parser.add_argument("--config", required=True, type=pathlib.Path)
    parser.add_argument(
        "-o",
        "--output-directory",
        default=pathlib.Path.cwd(),
        type=pathlib.Path,
        help="where artifacts copied out of the guest are written",
    )
    parser.add_argument(
        "--log-level",
        default="info",
        choices=["debug", "info", "warning", "error"],
    )
    parser.add_argument(
        "-I",
        "--interactive",
        action="store_true",
        help="boot the machines and open an IPython prompt instead of testing",
    )
    return parser


async def _run(args: argparse.Namespace, logger: AbstractLogger) -> None:
    config = config_module.load(args.config)
    args.output_directory.mkdir(parents=True, exist_ok=True)
    async with Driver(config, logger=logger, out_dir=args.output_directory) as driver:
        await driver.run()


def _run_interactive(args: argparse.Namespace, logger: AbstractLogger) -> None:
    from image_test_driver.interactive import InteractiveSession

    config = config_module.load(args.config)
    args.output_directory.mkdir(parents=True, exist_ok=True)
    driver = Driver(config, logger=logger, out_dir=args.output_directory)
    InteractiveSession(driver, logger).run()


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    logger: AbstractLogger = CompositeLogger([TerminalLogger()])
    logger.set_log_level(LogLevel[args.log_level.upper()])
    try:
        if args.interactive:
            _run_interactive(args, logger)
            return 0
        asyncio.run(_run(args, logger))
    except testscript.ScriptError as exc:
        logger.error(f"test script error: {exc}")
        return 1
    except RequestedAssertionFailed as exc:
        logger.error(f"!!! {exc}")
        return 1
    except MachineError as exc:
        logger.error(f"!!! {exc}")
        return 1
    except BaseExceptionGroup as group:
        causes = [e for e in group.exceptions if not isinstance(e, ExceptionGroup)]
        if len(causes) == 1:
            logger.error(f"!!! {causes[0]}")
            return 1
        for cause in causes:
            logger.error(f"!!! {cause}")
        return 1
    except Exception as exc:
        logger.error("\n" + testscript.format_exception(exc))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
