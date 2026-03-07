import os
import sys
import tempfile
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
        page.fill("#user", "root")
        page.fill("#password", "a")
        page.click("button[type='submit']")

        # note: this was recorded via setting environment variable PWDEBUG = 1
        # then modified to fix flaky timeouts
        print("Create and save spreadsheet")
        page.goto("http://localhost:8180/apps/files/files")
        (
            page.locator(".modal-container")
            .get_by_role("button", name="Close")
            .click(timeout=60 * 1000)
        )
        page.get_by_role("button", name="New").click()
        page.get_by_role("menuitem", name="New spreadsheet").click()
        page.get_by_role("button", name="Create").click()
        (
            page.locator("iframe")
            .content_frame.locator(".ui-custom-textarea-text-layer")
            .click(timeout=120 * 1000)
        )
        (
            page.locator("iframe")
            .content_frame.get_by_label("Clipboard area")
            .fill(TEST_CONTENT)
        )
        page.locator("iframe").content_frame.get_by_role("button", name="Save").click()
        page.wait_for_timeout(2000)  # let playwright save the recording
        (
            page.locator("iframe")
            .content_frame.get_by_role("button", name="Close document")
            .click()
        )

        print("Verify saved file contents")
        response = context.request.get(
            "http://localhost:8180/remote.php/webdav/New%20spreadsheet.xlsx"
        )

        if not response.ok:
            print(f"Error: could not download file from nextcloud. {response.status}")
            sys.exit(1)

        with tempfile.NamedTemporaryFile(delete=False, suffix=".xlsx") as tmp:
            tmp.write(response.body())
            download_path = tmp.name

        page.wait_for_timeout(2000)  # let it stay
        context.close()
        browser.close()

    try:
        wb = openpyxl.load_workbook(download_path)
        cell_value: str = wb.active["A1"].value
        if cell_value != TEST_CONTENT:
            print(
                f"Error: invalid content in downloaded file. expected: '{TEST_CONTENT}', actual: '{cell_value}'"
            )
            sys.exit(1)
    finally:
        os.remove(download_path)


if __name__ == "__main__":
    run_test()
