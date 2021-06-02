#! /somewhere/python3
import argparse
import time
from machine import Machine
from driver import Logger, Driver


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument(
        "-K",
        "--keep-vm-state",
        help="re-use a VM state coming from a previous run",
        action="store_true",
    )
    (cli_args, vm_scripts) = arg_parser.parse_known_args()

    log = Logger()

    driver = Driver(Machine, log, vm_scripts, cli_args.keep_vm_state)
    driver.export_symbols()

    tic = time.time()
    driver.run_tests()
    toc = time.time()
    print("test script finished in {:.2f}s".format(toc - tic))
