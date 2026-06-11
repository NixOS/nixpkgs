#!/usr/bin/env python3
import argparse
import logging
import pathlib
import subprocess
import time


def parse_cli_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--log-file-path",
        required=True,
        type=str,
        help="The path to the log file (without the '.log' suffix/extension)",
    )
    parser.add_argument(
        "--cosmic-reader-pdf",
        required=True,
        type=str,
        help="The PDF that the `cosmic-reader` should open for testing",
    )
    args = parser.parse_args()
    return args


def wait_for_cosmic_de_readiness() -> None:
    """
    Wait for the COSMIC DE to be ready, before running the tests. This
    is done by waiting on the supposedly last component of the COSMIC
    DE to be "ready." That component is the notification watcher, of
    the `cosmic-applet` derivation.
    """
    logging.info("=" * 80)
    logging.info("Waiting for COSMIC DE to complete initialization")

    notification_watcher_wait_deadline = time.monotonic() + 360
    notification_watcher_exists = False
    while time.monotonic() < notification_watcher_wait_deadline:
        busctl_process = subprocess.run(
            ["busctl", "--user", "status", "com.system76.CosmicStatusNotifierWatcher"],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        if busctl_process.returncode == 0:
            notification_watcher_exists = True
            break
        else:
            time.sleep(1)
    logging_msg = "The COSMIC DE is "
    if notification_watcher_exists:
        logging.info(f"{logging_msg} ready")
    else:
        logging.error(f"{logging_msg} not ready")
    return


def perform_gui_application_test(cli_args: argparse.Namespace) -> None:
    """
    1. Start one GUI application as a background process.
    2. Wait unil it has been confimred that the GUI application is
       running.
    3. Kill the background process of the GUI application.

    Any breakage in this flow is considered a failure of the test for
    the GUI application.
    """
    logging.info("=" * 80)
    logging.info("Performing test to launch GUI applications")

    gui_apps_to_test = {
        "com.system76.CosmicEdit": [
            "cosmic-edit",
        ],
        "com.system76.CosmicFiles": [
            "cosmic-files",
        ],
        "com.system76.CosmicPlayer": [
            "cosmic-player",
        ],
        "com.system76.CosmicReader": [
            "cosmic-reader",
            cli_args.cosmic_reader_pdf,
        ],
        "com.system76.CosmicSettings": [
            "cosmic-settings",
        ],
        "com.system76.CosmicStore": [
            "cosmic-store",
        ],
        "com.system76.CosmicTerm": [
            "cosmic-term",
        ],
    }

    for gui_app_id, gui_app_command in gui_apps_to_test.items():
        logging.info(f"Running: {gui_app_command}")
        gui_app_bg_process = subprocess.Popen(
            gui_app_command,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        gui_app_bg_process_deadline = time.monotonic() + 30
        gui_app_is_running = False

        while time.monotonic() < gui_app_bg_process_deadline and not gui_app_is_running:
            lswt_process = subprocess.run(
                [
                    "lswt",
                    "--custom",
                    "a",
                ],
                check=False,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
            )
            lswt_process_stdout = lswt_process.stdout.strip()
            if lswt_process_stdout:
                if gui_app_id in lswt_process_stdout.splitlines():
                    gui_app_is_running = True
            time.sleep(1)
        pkill_process = subprocess.run(
            ["pkill", gui_app_command[0]],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )

        log_message = (
            f"The GUI application test for '{gui_app_command[0]}' ({gui_app_id})"
        )
        if gui_app_is_running:
            logging.info(f"{log_message} passed")
        else:
            logging.error(f"{log_message} failed")
    return


def main() -> None:
    cli_args = parse_cli_args()
    logging.basicConfig(
        level=logging.INFO,
        format=f"%(asctime)sZ [%(levelname)s] [L:%(lineno)d] %(message)s",
        datefmt="%H:%M:%S",
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler(f"{cli_args.log_file_path}.log", mode="w"),
        ],
    )
    logging.Formatter.converter = time.gmtime
    logging.info(f"Logging to '{cli_args.log_file_path}.log'")

    # Wait for the DE to be ready
    wait_for_cosmic_de_readiness()

    # tests go here
    perform_gui_application_test(cli_args)

    pathlib.Path(f"{cli_args.log_file_path}.done").touch()
    return


if __name__ == "__main__":
    main()
