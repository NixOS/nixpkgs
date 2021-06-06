#! /somewhere/python3
import argparse
import time
import os
import logging.config
import ptpython.repl

from pathlib import Path

from driver import Driver

import logging

_ = logging.getLogger("machine.CTL")  # machine controle plane
_ = logging.getLogger("machine.LOG")  # machine serial logs
_ = logging.getLogger("vlan.CTL")  # vlan control plane
_ = logging.getLogger("vlan.LOG")  # vlan serial logs

if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(prog="@name@")
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
        default=os.environ.get("startScripts"),
        required=True,
        nargs="+",
        help="start scripts for participating virtual machines",
    )
    arg_parser.add_argument(
        "--vlans",
        required=True,
        default=os.environ.get("vlans"),
        nargs="+",
        type=int,
        help="vlans to span by the driver",
    )
    arg_parser.add_argument(
        "--logging-config",
        help="provide a python config file for custom logging",
        default=Path(__file__).parent / "logging.yaml",
    )
    arg_parser.add_argument(
        "test-script",
        default=os.environ.get("testScript"),
        help="the test script to run",
        type=argparse.FileType("r"),
    )

    args = arg_parser.parse_args()
    logging.config.fileConfig(args.logging_config)
    if not args.keep_vm_state:
        logging.info("Machine state will be reset. To keep it, pass --keep-vm-state")

    driver = Driver(
        args.start_scripts, args.vlans, args.test_script, args.keep_vm_state
    )

    if not args.interactive():
        tic = time.time()
        driver.start_all()
        driver.run_tests()
        driver.join_all()
        toc = time.time()
        logging.info(f"test script finished in {(toc-tic):.2f}s")
    else:
        ptpython.repl.embed(driver.test_symbols(), {})
