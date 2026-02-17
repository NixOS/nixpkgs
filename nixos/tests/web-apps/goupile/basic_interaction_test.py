import os
import openpyxl
import tempfile
from playwright.sync_api import sync_playwright

BASE_URL = "http://localhost:8889"

# NOTE: these are the passwords
ADMIN_PASSWD = "car-shop-in-the-mall"
ALICE_PASSWD = "user-goes-to-the-car-shop"


def run_test():
    is_headful = os.getenv("HEADFUL") == "1"

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=not is_headful)
        context = browser.new_context(
            accept_downloads=True, record_video_dir="/tmp/videos/"
        )
        # more default timeout for slow nixos test vms
        context.set_default_timeout(90 * 1000)
        page = context.new_page()

        page.goto(f"{BASE_URL}/admin")

        # admin and doman setup
        page.get_by_role("textbox", name="Domain name *").fill("domain")
        page.get_by_role("textbox", name="Domain title *").fill("domain")
        page.get_by_role("textbox", name="Password *").fill(ADMIN_PASSWD)
        page.get_by_role("textbox", name="Confirmation").fill(ADMIN_PASSWD)
        page.get_by_role("textbox", name="Decryption key *").click()
        page.get_by_role("button", name="Installer").click()

        # login to admin dashboard as admin
        page.get_by_role("textbox", name="Username *").fill("admin")
        page.get_by_role("textbox", name="Password *").fill(ADMIN_PASSWD)
        page.get_by_role("button", name="Login").click()

        # create a sample project, it will switch the view to project's configure page
        page.get_by_text("Create new project").click()
        page.get_by_role("textbox", name="Name *").fill("proj1")
        page.get_by_role("button", name="Create").click()

        # create a test non-root user, alice
        page.get_by_text("Create new user").click()
        page.get_by_role("textbox", name="Username *").fill("alice")
        page.get_by_role("button", name="No", exact=True).click()
        page.get_by_role("textbox", name="Password *").fill(ALICE_PASSWD)
        page.get_by_role("textbox", name="Confirmation").fill(ALICE_PASSWD)
        page.get_by_role("button", name="Create").click()

        # give alice, permissions to access the project
        page.get_by_role("button", name="Assign").nth(1).click()
        page.get_by_text("Read", exact=True).click()
        page.get_by_text("Save", exact=True).click()
        page.get_by_text("Export", exact=True).click()
        page.get_by_text("Download", exact=True).click()

        # Open the project in new page
        page.locator("form").get_by_role("button", name="Edit").click()
        with page.expect_popup() as page1_info:
            page.get_by_role("link", name="access").click()
        page1 = page1_info.value
        page1.set_default_timeout(120 * 1000)

        # fill entries as admin (enter 1 for everything)
        page1.get_by_role("button", name="Create new record").click()

        page1.locator("#ins_tiles").get_by_text("Introduction").click()
        page1.get_by_role("textbox", name="Inclusion date *").fill("2000-01-01")
        page1.get_by_role("spinbutton", name="Age *").click()
        page1.get_by_role("spinbutton", name="Age *").fill("1")
        page1.get_by_role("button", name="Save").click()
        page1.wait_for_timeout(1000)

        page1.get_by_role("button", name="Advanced").click()
        page1.get_by_role("spinbutton", name="Age *").click()
        page1.get_by_role("spinbutton", name="Age *").fill("1")
        page1.get_by_role("button", name="Save").click()
        page1.wait_for_timeout(1000)

        page1.get_by_role("button", name="Page layout").click()
        page1.get_by_role("spinbutton", name="Variable A1").fill("1")
        page1.get_by_role("button", name="Save").click()
        page1.wait_for_timeout(1000)

        # create export #1
        page1.get_by_role("button", name="Data").click()
        page1.wait_for_timeout(1000)

        page1.get_by_role("button", name="Data exports").click()
        with page1.expect_download() as download_info:
            page1.get_by_role("button", name="Create export").click()

        # logout as admin
        page.get_by_role("button", name="admin", exact=True).click()
        with page.expect_popup() as page2_info:
            page.get_by_role("link", name="access").click()
        page2 = page2_info.value
        page2.set_default_timeout(120 * 1000)

        page2.get_by_role("button", name="admin").click()
        page2.get_by_role("button", name="Logout").click()

        # login as alice
        page2.get_by_role("textbox", name="Username *").fill("alice")
        page2.get_by_role("textbox", name="Password *").fill(ALICE_PASSWD)
        page2.get_by_role("button", name="Login").click()

        # create entry as alice (fill `2` for everything)
        page2.get_by_role("button", name="Create new record").click()

        page2.get_by_text("1 Introduction").click()
        page2.get_by_role("textbox", name="Inclusion date *").fill("2000-01-01")
        page2.get_by_role("spinbutton", name="Age *").click()
        page2.get_by_role("spinbutton", name="Age *").fill("2")
        page2.get_by_role("button", name="Save").click()
        page2.wait_for_timeout(1000)

        page2.get_by_role("button", name="Advanced").click()
        page2.get_by_role("spinbutton", name="Age *").click()
        page2.get_by_role("spinbutton", name="Age *").fill("2")
        page2.get_by_role("button", name="Save").click()
        page2.wait_for_timeout(1000)

        page2.get_by_role("button", name="Page layout").click()
        page2.get_by_role("spinbutton", name="Variable A1").click()
        page2.get_by_role("spinbutton", name="Variable A1").fill("2")
        page2.get_by_role("button", name="Save").click()
        page2.wait_for_timeout(1000)

        # create export #2
        page2.get_by_role("button", name="Data").click()
        page2.wait_for_timeout(1000)

        page2.get_by_role("button", name="Data exports").click()
        page2.get_by_role("button", name="Previous exports").click()

        with page2.expect_download() as download1_info:
            page2.locator("a").filter(has_text="Download").click()

        download1 = download1_info.value
        save_path1 = os.path.join(tempfile.gettempdir(), download1.suggested_filename)
        download1.save_as(save_path1)

        print(f"exported all records to {save_path1}")

        page2.get_by_role("button", name="Data exports").click()
        with page2.expect_download() as download2_info:
            page2.get_by_role("button", name="Create export").click()

        download2 = download2_info.value
        save_path2 = os.path.join(tempfile.gettempdir(), download2.suggested_filename)
        download2.save_as(save_path2)

        print(f"exported all records to {save_path2}")

        context.close()
        browser.close()

    # check that exported files have correct entries

    wb1 = openpyxl.load_workbook(save_path1)
    for sheet, cell in zip(["intro", "advanced", "layout"], ["D2", "D2", "C2"]):
        val = wb1[sheet][cell].value
        assert val == 1, f"Sheet {sheet}, Cell {cell}: Expected 1 (admin), got {val}"

    wb2 = openpyxl.load_workbook(save_path2)
    for sheet, cell in zip(["intro", "advanced", "layout"], ["D3", "D3", "C3"]):
        val = wb2[sheet][cell].value
        assert val == 2, f"Sheet {sheet}, Cell {cell}: Expected 2 (alice), got {val}"

    print("Test passed successfully!")


if __name__ == "__main__":
    run_test()
