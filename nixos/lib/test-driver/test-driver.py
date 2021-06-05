#! /somewhere/python3
import argparse
import time
import os

import ptpython.repl

from logger import Logger
from driver import Driver

if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument(
        "-S",
        "--start-scripts",
        default=os.environ.get("startScripts"),
        required=True,
        nargs="+",
        help="start scripts for participating virtual machines",
    )
    arg_parser.add_argument(
        "-V",
        "--vlans",
        required=True,
        default=os.environ.get("vlans"),
        nargs="+",
        type=int,
        help="vlans to span by the driver",
    )
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
        "test-script",
        default=os.environ.get("testScript"),
        help="the test script to run",
        type=argparse.FileType('r'),
    )

    args = arg_parser.parse_args()

    logger = Logger()
    if not args.keep_vm_state:
        logger("Machine state will be reset. To keep it, pass --keep-vm-state")

    driver = Driver(
        logger,
        args.start_scripts,
        args.test_script,
        args.keep_vm_state
    )

    if not args.interactive():
        tic = time.time()
        driver.start_all()
        driver.run_tests()
        driver.join_all()
        toc = time.time()
        print(f"test script finished in {(toc-tic):.2f}s")
    else:
        ptpython.repl.embed(driver.test_symbols(), {})
