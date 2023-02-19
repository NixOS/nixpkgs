from dataclasses import dataclass
from os import mkdir
import os.path
import time
from typing import Set

import structlog
from structlog.contextvars import bind_contextvars, reset_contextvars

# shadow root support only in chromium based browsers as of selenium 4.8.0
# https://github.com/SeleniumHQ/selenium/blob/selenium-4.8.0/py/selenium/webdriver/remote/webelement.py#L245-L248
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.alert import Alert
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

log = structlog.get_logger()


# encapsulate selectors to find html elements
@dataclass
class S:
    by: By
    value: str

    # retrieve the shadow dom of the tag
    shadow_root: bool = False

    # retrieve all matching tags
    multiple: bool = False


# helper function to navigate through nested shadow roots
def select(*selectors: S, origin):
    doc = origin
    for sel in selectors:
        if sel.multiple:
            if isinstance(doc, list):
                raise RuntimeError(
                    "The multiple qualifier can only appear once in a selection group"
                )
            else:
                doc = doc.find_elements(sel.by, sel.value)
                if sel.shadow_root:
                    doc = [x.shadow_root for x in doc]
        else:
            if isinstance(doc, list):
                doc = [x.find_element(sel.by, sel.value) for x in doc]
                if sel.shadow_root:
                    doc = [x.shadow_root for x in doc]
            else:
                doc = doc.find_element(sel.by, sel.value)
                if sel.shadow_root:
                    doc = doc.shadow_root
    return doc


# Custom wait implementation for nested elements
class NestedElementPresent:
    def __init__(self, *selectors: S):
        self.selectors = selectors

    def __call__(self, driver):
        result = select(*self.selectors, origin=driver)
        return result


def write(input, value: str, field_name: str):
    input.click()
    # input.clear() does not work properly :(
    for _ in range(16):
        input.send_keys(Keys.BACKSPACE)
    input.send_keys(value)
    log.info(f"Set {field_name}", value=value)


ARTIFACT_PATH = "/run/artifacts"
mkdir(ARTIFACT_PATH)

options = Options()
options.add_argument("--headless")
options.add_argument("--no-sandbox")  # run as root
options.binary_location = "/run/current-system/sw/bin/chromium"
driver = Chrome(
    options=options,
)
wait = WebDriverWait(driver, 10)

# increase viewport, so everything becomes visible w/o scrolling
driver.set_window_size(720, 1280)


def onboarding():
    # wait for the site to load
    url = "http://localhost:8123/onboarding.html"
    log.info("Loading", url=url)
    driver.get(url)
    wait.until(EC.title_contains("Home Assistant"))
    log.info("Ready", url=url)

    # move the viewport around to trigger a redraw
    body = driver.find_element(By.TAG_NAME, "body")
    body.send_keys(Keys.SPACE)
    body.send_keys(Keys.SHIFT + Keys.SPACE)

    onboarding_step_user()
    onboarding_step_core_config()
    onboarding_step_analytics()


@dataclass
class Credentials:
    username: str
    password: str


def onboarding_step_user() -> Credentials:
    ctx = bind_contextvars(step="user")

    # wait until the page is rendered
    log.info("Waiting for onboarding-create-user")
    onboarding_create_user = wait.until(
        NestedElementPresent(
            S(By.CSS_SELECTOR, "ha-onboarding", shadow_root=True),
            S(By.CSS_SELECTOR, "onboarding-create-user", shadow_root=True),
        )
    )
    log.info("Found onboarding-create-user", tag=onboarding_create_user)

    driver.save_screenshot(os.path.join(ARTIFACT_PATH, "onboarding_step1.png"))

    name, username, password, confirm = select(
        S(By.CSS_SELECTOR, "ha-form", shadow_root=True),
        S(By.CSS_SELECTOR, "ha-selector", shadow_root=True, multiple=True),
        S(By.CSS_SELECTOR, "ha-selector-text", shadow_root=True),
        S(By.CSS_SELECTOR, "ha-textfield", shadow_root=True),
        S(By.CSS_SELECTOR, "input.mdc-text-field__input"),
        origin=onboarding_create_user,
    )

    creds = Credentials("nixos", "test")

    write(name, creds.username, "Name")
    write(username, "NixOS Testuser", "Username")
    write(password, creds.password, "Password")
    write(confirm, creds.password, "Confirm password")

    driver.save_screenshot(
        os.path.join(ARTIFACT_PATH, "onboarding_step1_logindata.png")
    )

    log.info("Submit")
    select(
        S(By.CSS_SELECTOR, "mwc-button"), origin=onboarding_create_user
    ).click()

    reset_contextvars(**ctx)

    return creds


def onboarding_step_core_config():
    ctx = bind_contextvars(step="core_config")

    # wait until the page is rendered
    log.info("Waiting for onboarding-create-user")
    onboarding_core_config = wait.until(
        NestedElementPresent(
            S(By.CSS_SELECTOR, "ha-onboarding", shadow_root=True),
            S(By.CSS_SELECTOR, "onboarding-core-config", shadow_root=True),
        )
    )
    log.info("Found onboarding-core-config")

    driver.save_screenshot(os.path.join(ARTIFACT_PATH, "onboarding_step2.png"))

    # set home name
    home = select(
        S(By.CSS_SELECTOR, "ha-textfield", shadow_root=True),
        S(By.CSS_SELECTOR, "input"),
        origin=onboarding_core_config,
    )
    write(home, "NixOS Testdriver", "Installation name")

    # try environment detection, will fail and only set language to "en"
    select(
        S(By.CSS_SELECTOR, "div.middle-text mwc-button"), origin=onboarding_core_config
    ).click()
    log.info("Detect environment")

    driver.save_screenshot(os.path.join(ARTIFACT_PATH, "onboarding_step2_detect.png"))

    map_marker = select(
        S(By.CSS_SELECTOR, "ha-locations-editor", shadow_root=True),
        S(By.CSS_SELECTOR, "ha-map", shadow_root=True),
        S(By.CSS_SELECTOR, "div.leaflet-marker-pane img"),
        origin=onboarding_core_config
    )
    log.info("Found leaflet-marker-pane", tag=map_marker)
    ActionChains(driver).click().click_and_hold().move_by_offset(100, 100).release().perform()
    log.info("Moved location marker")

    country, lang, tz, elevation, currency = select(
        S(By.CSS_SELECTOR, "div.row ha-textfield", shadow_root=True, multiple=True),
        S(By.CSS_SELECTOR, "input"),
        origin=onboarding_core_config,
    )
    write(country, "DE", "Country")
    print(tz.tag_name)
    write(tz, "UTC", "Time Zone")
    write(elevation, "123", "Elevation")
    write(currency, "EUR", "Currency")

    driver.save_screenshot(os.path.join(ARTIFACT_PATH, "onboarding_step2_inputs.png"))

    log.info("Submit")
    select(
        S(By.CSS_SELECTOR, "div.footer mwc-button"), origin=onboarding_core_config
    ).click()

    Alert(driver).accept()

    driver.save_screenshot(os.path.join(ARTIFACT_PATH, "onboarding_step2_submit.png"))

    reset_contextvars(**ctx)



def onboarding_step_analytics():
    ctx = bind_contextvars(step="analytics")

    # wait until the page is rendered
    log.info("Waiting for onboarding-analytics")
    onboarding_analytics = wait.until(
        NestedElementPresent(
            S(By.CSS_SELECTOR, "ha-onboarding", shadow_root=True),
            S(By.CSS_SELECTOR, "onboarding-analytics", shadow_root=True),
        )
    )
    log.info("Found onboarding-analytics", tag=onboarding_analytics)

    driver.save_screenshot(os.path.join(ARTIFACT_PATH, "onboarding_step3.png"))


onboarding()

driver.close()
print("close")
