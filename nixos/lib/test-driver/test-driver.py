#! /somewhere/python3
import argparse
import time
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
    (cli_args, vm_scripts) = arg_parser.parse_known_args()

    logger = Logger()
    if not cli_args.keep_vm_state:
        logger("Machine state will be reset. To keep it, pass --keep-vm-state")
    driver = Driver(logger, vm_scripts, cli_args.keep_vm_state)

    tic = time.time()
    driver.run_tests()
    toc = time.time()
    print(f"test script finished in {(toc-tic):.2f}s")
