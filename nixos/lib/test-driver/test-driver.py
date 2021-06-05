#! /somewhere/python3
import argparse
import time
import os

from logger import Logger
from driver import Driver

if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument(
        "-K",
        "--keep-vm-state",
        help="re-use a VM state coming from a previous run",
        action="store_true",
    )
    # 'rest' effectively are a list of paths to nix scripts that start the
    # machines. They are passed as cli args after
    (cli_args, rest) = arg_parser.parse_known_args()

    interactive = False
    interactive_tests = os.environ.get("testScript")
    tests = os.environ.get("tests", interactive_tests)
    if interactive_tests is not None:
        interactive = True

    logger = Logger()
    if not cli_args.keep_vm_state:
        logger("Machine state will be reset. To keep it, pass --keep-vm-state")
    driver = Driver(logger, rest, tests, interactive, cli_args.keep_vm_state)

    tic = time.time()
    driver.run_tests()
    toc = time.time()
    print(f"test script finished in {(toc-tic):.2f}s")
