import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "playwright";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ phaer ];
  };

  nodes.machine =
    { pkgs, ... }: {
      environment.variables = {
        NIX_MANUAL_DOCROOT =
        "file://${pkgs.nix.doc}/share/doc/nix/manual/index.html";
        PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
      };
      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "test_playwright" {
          libraries = [ pkgs.python3Packages.playwright ];
        } ''
            import sys
            from playwright.sync_api import sync_playwright
            from playwright.sync_api import expect

            browsers = ["chromium", "firefox", "webkit"]
            if len(sys.argv) != 3 or sys.argv[1] not in browsers:
                print(f"usage: {sys.argv[0]} [{'|'.join(browsers)}] <url>")
                sys.exit(1)
            browser_type = sys.argv[1]
            url = sys.argv[2]
            with sync_playwright() as p:
                print(f"Running test on {browser_type}")
                browser = getattr(p, browser_type).launch()
                context = browser.new_context()
                page = context.new_page()
                page.goto(url)
                expect(page.get_by_text("Nix Reference Manual")).to_be_visible()
          '')
      ];
    };


  testScript =
    ''
      for browser in ["firefox", "chromium", "webkit"]:
          with subtest(f"Render Nix Manual in {browser}"):
              machine.succeed(f"test_playwright {browser} $NIX_MANUAL_DOCROOT")
    '';

})
