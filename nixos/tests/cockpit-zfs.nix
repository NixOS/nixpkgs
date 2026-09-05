{ pkgs, lib, ... }:

let
  user = "alice"; # from ./common/user-account.nix
  password = "foobar"; # from ./common/user-account.nix

  pool = "testpool";
in
{
  name = "cockpit-zfs";
  meta = {
    maintainers = with lib.maintainers; [ eymeric ];
  };
  nodes = {
    server =
      { pkgs, config, ... }:
      {
        imports = [ ./common/user-account.nix ];
        # Permit passwordless superuser elevation so Cockpit's "superuser: try"
        # data channels (used by the plugin's get-pools/get-datasets scripts) can
        # run without an interactive authentication prompt in the headless test.
        # polkit is left disabled so Cockpit resolves superuser via passwordless
        # sudo deterministically instead of an interactive polkit prompt.
        security.sudo.wheelNeedsPassword = false;
        users.users.${user} = {
          extraGroups = [ "wheel" ];
        };

        # Give ZFS a spare disk to create a pool on.
        virtualisation.emptyDiskImages = [ 2048 ];
        networking.hostId = "c0ff33fe";
        boot.supportedFilesystems = [ "zfs" ];
        environment.systemPackages = [ pkgs.parted ];

        services.cockpit = {
          enable = true;
          port = 7890;
          openFirewall = true;
          plugins = [ pkgs.cockpit-zfs ];
          allowed-origins = [
            "https://server:${toString config.services.cockpit.port}"
          ];
        };
      };
    client =
      { pkgs, ... }:
      {
        imports = [ ./common/user-account.nix ];
        environment.systemPackages =
          let
            seleniumScript =
              pkgs.writers.writePython3Bin "selenium-script"
                { libraries = with pkgs.python3Packages; [ selenium ]; }
                ''
                  from selenium import webdriver
                  from selenium.common.exceptions import (
                      NoSuchElementException,
                      TimeoutException,
                  )
                  from selenium.webdriver.common.by import By
                  from selenium.webdriver.firefox.options import Options
                  from selenium.webdriver.support.ui import WebDriverWait
                  from selenium.webdriver.support import expected_conditions as EC


                  def log(msg):
                      from sys import stderr
                      print(f"[*] {msg}", file=stderr)


                  log("Initializing")

                  options = Options()
                  options.add_argument("--headless")
                  # Cockpit serves over a self-signed TLS cert by default; allow the
                  # headless browser to connect to it.
                  options.accept_insecure_certs = True

                  service = webdriver.FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501
                  driver = webdriver.Firefox(options=options, service=service)

                  driver.implicitly_wait(10)

                  log("Opening homepage")
                  driver.get("https://server:7890")


                  def wait_elem(by, query, timeout=10):
                      wait = WebDriverWait(driver, timeout)
                      wait.until(EC.presence_of_element_located((by, query)))


                  def wait_title_contains(title, timeout=30):
                      wait = WebDriverWait(driver, timeout)
                      wait.until(EC.title_contains(title))


                  def find_element(by, query):
                      return driver.find_element(by, query)


                  log("Waiting for the homepage to load")

                  # cockpit sets initial title as hostname
                  wait_title_contains("server")
                  wait_elem(By.CSS_SELECTOR, 'input#login-user-input')

                  log("Homepage loaded!")

                  log("Filling out username")
                  login_input = find_element(By.CSS_SELECTOR, 'input#login-user-input')
                  login_input.clear()
                  login_input.send_keys("${user}")

                  log("Filling out password")
                  password_input = find_element(
                      By.CSS_SELECTOR, 'input#login-password-input'
                  )
                  password_input.clear()
                  password_input.send_keys("${password}")

                  log("Submitting credentials for login")
                  driver.find_element(By.CSS_SELECTOR, 'button#login-button').click()

                  log("Waiting dashboard to load")
                  wait_title_contains("${user}@server")

                  log("Looking for that banner that tells about limited access")
                  wait_elem(By.CSS_SELECTOR, 'iframe.container-frame', timeout=30)
                  container_iframe = find_element(
                      By.CSS_SELECTOR, 'iframe.container-frame'
                  )
                  driver.switch_to.frame(container_iframe)
                  # Wait for the overview iframe to render the limited-access alert.
                  phrase = "Web console is running in limited access mode"
                  WebDriverWait(driver, 30).until(
                      lambda d: phrase in d.page_source
                  )

                  log("Clicking the sudo button")
                  # The button text toggles, e.g. "Turn on administrative access" ->
                  # "Turn off administrative access"; clicking whichever is present is
                  # idempotent, so just click it to make sure admin is enabled.
                  for button in driver.find_elements(By.TAG_NAME, "button"):
                      if 'admin' in button.text.casefold():
                          button.click()
                          break

                  # Wait for the privileged bridge to actually become active (the
                  # banner flips from "limited access mode" to "administrative
                  # privileges"). Without this, the plugin's "superuser: try" data
                  # channels race the bridge startup and intermittently hang.
                  WebDriverWait(driver, 30).until(
                      lambda d: "administrative privileges" in d.page_source
                      or "limited access mode" not in d.page_source
                  )
                  driver.switch_to.default_content()

                  log("Opening the 45Drives ZFS plugin")
                  # Navigate via the shell sidebar (matching how a user reaches the
                  # plugin) rather than driver.get()-ing the raw plugin URL, so we
                  # exercise the real integration. If the nav item isn't found we
                  # fall back to the direct URL.
                  try:
                      wait_elem(By.CSS_SELECTOR, 'a', timeout=30)
                      for a in driver.find_elements(By.TAG_NAME, "a"):
                          dn = a.get_attribute("data-name") or ""
                          href = a.get_attribute("href") or ""
                          if (
                              dn == "zfs"
                              or href.rstrip("/").endswith("/zfs")
                              or "45drives zfs" in (a.text or "").casefold()
                          ):
                              a.click()
                              break
                      else:
                          driver.get("https://server:7890/zfs/")
                  except (NoSuchElementException, TimeoutException):
                      driver.get("https://server:7890/zfs/")

                  log("Switching into the ZFS plugin iframe")
                  # Wait until the shell swaps the content iframe to the plugin.
                  WebDriverWait(driver, 30).until(
                      lambda d: any(
                          "zfs" in (ifr.get_attribute("src") or "")
                          for ifr in d.find_elements(By.TAG_NAME, "iframe")
                      )
                  )
                  for iframe in driver.find_elements(By.TAG_NAME, "iframe"):
                      src = iframe.get_attribute("src") or ""
                      if "zfs" in src:
                          log(f"MATCHED iframe src: {src}")
                          driver.switch_to.frame(iframe)
                          break
                  else:
                      raise AssertionError("ZFS plugin iframe not found")

                  # The pool list renders the pool name, status and usage data.
                  # Assert on the visible text so the check is robust against the
                  # plugin's CSS/DOM class names changing between releases.
                  log("Waiting for the pool to be detected by the plugin")
                  WebDriverWait(driver, 60).until(
                      lambda d: "${pool}" in (d.find_element(By.TAG_NAME, "body").text)
                  )

                  text = driver.find_element(By.TAG_NAME, "body").text
                  log(f"Plugin shows: {text[:400]!r}")

                  assert "ONLINE" in text, (
                      f"expected pool status ONLINE, got:\n{text}"
                  )
                  # The pool has data: capacity (%), used/total, and the backing
                  # vdev. If the plugin were not reading real ZFS state these strings
                  # (derived from `zpool`/`zfs` output) would be absent.
                  assert "% Full" in text and "Used" in text and "Total" in text, (
                      f"expected usage/percentage figures, got:\n{text}"
                  )
                  assert "vdb1" in text, (
                      f"expected vdev 'vdb1' in the plugin output, got:\n{text}"
                  )

                  log("ZFS pool detected and data is present!")
                  driver.close()
                '';
          in
          with pkgs;
          [
            firefox-unwrapped
            geckodriver
            seleniumScript
          ];
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("sockets.target")
    server.wait_for_open_port(7890)
    # Port open is not enough: cockpit-ws may still be finishing startup.
    server.wait_until_succeeds("curl -k https://127.0.0.1:7890 -o /dev/null")

    # Create a ZFS pool with a couple of datasets so the plugin has data to show.
    server.succeed(
        "parted --script /dev/vdb -- mklabel msdos mkpart primary 1MiB 100%",
        "udevadm settle",
        "zpool create ${pool} /dev/vdb1",
        "zfs create ${pool}/data",
        "zfs create ${pool}/data/important",
        "udevadm settle",
    )

    client.wait_until_succeeds("curl -k https://server:7890 -o /dev/stderr")
    client.succeed("PYTHONUNBUFFERED=1 selenium-script")
  '';
}
