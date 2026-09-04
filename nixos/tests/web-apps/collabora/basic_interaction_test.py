import os
import sys
import tempfile
import time
from playwright.sync_api import sync_playwright
import openpyxl

TEST_CONTENT = "Welcome to Nixos"


def run_test():
    is_headful = os.getenv("HEADFUL") == "1"

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=not is_headful)

        context = browser.new_context(
            accept_downloads=True, record_video_dir="/tmp/videos/"
        )
        page = context.new_page()

        print("Log in")
        page.goto("http://localhost:8180/")
        page.locator("#user").fill("root")
        page.locator("#password").fill("a")
        page.locator("button[type='submit']").click()

        print("Create spreadsheet")
        page.goto("http://localhost:8180/apps/files/files")

        page.locator(".modal-container").get_by_role("button", name="Close").click(
            timeout=60 * 1000
        )
        page.get_by_role("button", name="New").click()
        page.get_by_role("menuitem", name="New spreadsheet").click()
        page.get_by_role("button", name="Create").click()

        iframe = page.locator("iframe").content_frame

        print("waiting for UI to load")
        iframe.locator("#toolbar-up").wait_for(state="visible", timeout=60 * 1000)
        time.sleep(5)

        text_layer = iframe.locator(".ui-custom-textarea-text-layer")
        text_layer.click()

        page.keyboard.type(TEST_CONTENT, delay=100)
        page.keyboard.press("Enter")
        time.sleep(5)

        iframe.get_by_role("button", name="Save").click()
        time.sleep(5)

        iframe.get_by_role("button", name="Close document").click(force=True)
        time.sleep(5)

        def verify_remote_file() -> str:
            response = context.request.get(
                "http://localhost:8180/remote.php/webdav/New%20spreadsheet.xlsx"
            )
            if not response.ok:
                return "File locked or unavailable"

            with tempfile.NamedTemporaryFile(delete=False, suffix=".xlsx") as tmp:
                tmp.write(response.body())
                download_path = tmp.name

            try:
                wb = openpyxl.load_workbook(download_path)
                return str(wb.active["A1"].value)
            except Exception:
                return "File corrupt or mid-write"
            finally:
                if os.path.exists(download_path):
                    os.remove(download_path)

        timeout_seconds = 30
        start_time = time.time()
        is_successful = False
        last_value = None

        while time.time() - start_time < timeout_seconds:
            last_value = verify_remote_file()

            if last_value == TEST_CONTENT:
                print("Content verified successfully")
                is_successful = True
                break

            time.sleep(1)

        if not is_successful:
            print(
                f"Error: Backend failed to sync within {timeout_seconds} seconds. Last seen value: '{last_value}'"
            )
            sys.exit(1)

        context.close()
        browser.close()


if __name__ == "__main__":
    run_test()
