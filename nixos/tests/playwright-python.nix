{ pkgs, ... }:
{
  name = "playwright-python";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ phaer ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.variables = {
        NIX_MANUAL_DOCROOT = "file://${pkgs.nix.doc}/share/doc/nix/manual/index.html";
        PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
      };
      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "test_playwright"
          {
            libraries = [ pkgs.python3Packages.playwright ];
          }
          ''
            import sys
            import re
            from playwright.sync_api import sync_playwright
            from playwright.sync_api import expect

            browsers = {
              "chromium": {'args': ["--headless", "--disable-gpu"], 'channel': 'chromium'},
              "firefox": {},
              "webkit": {}
            }
            needle = re.compile("Nix.*Reference Manual")
            if len(sys.argv) != 3 or sys.argv[1] not in browsers.keys():
                print(f"usage: {sys.argv[0]} [{'|'.join(browsers.keys())}] <url>")
                sys.exit(1)
            browser_name = sys.argv[1]
            url = sys.argv[2]
            browser_kwargs = browsers.get(browser_name)
            args = ' '.join(browser_kwargs.get('args', []))
            print(f"Running test on {browser_name} {args}")
            with sync_playwright() as p:
                browser = getattr(p, browser_name).launch(**browser_kwargs)
                context = browser.new_context()
                page = context.new_page()
                page.goto(url)
                expect(page.get_by_text(needle)).to_be_visible()
          ''
        )
      ];
    };

  testScript = ''
    # FIXME: Webkit segfaults
    for browser in ["firefox", "chromium"]:
        with subtest(f"Render Nix Manual in {browser}"):
            machine.succeed(f"test_playwright {browser} $NIX_MANUAL_DOCROOT")
  '';

}
