# This test tests following capabilities of Firefox / fontconfig:
# 1. rendering content of simple HTML body
#    (least likely to fail -> tested first & basis for screenshot)
# 2. rendering text in the url bar
# 3. rendering page title in the tab bar
#    (preventing regression of https://github.com/NixOS/nixpkgs/issues/540847)
{
  lib,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.strings) escapeNixString;

  # these texts should be different to avoid false positives in the tests
  pageFileName = "test-page.html";
  pageTitle = "World Hello"; # mind width of tab bar so everything fits
  pageBody = "Lorem ipsum dolor sit amet."; # mind maximum width of HTML content so text does not wrap

  # pageTitle must not appear in the body (for 3.)
  html = ''
    <!DOCTYPE html>
    <html>
      <head><title>${pageTitle}</title></head>
      <body>
        <p>${pageBody}</p>
      </body>
    </html>
  '';
in
{
  name = "firefox-font-rendering";
  meta.maintainers = with lib.maintainers; [
    Zocker1999NET
  ];
  nodes.machine =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        ../common/wayland-cage.nix
      ];

      programs.firefox.enable = true;

      # increase resolution & scale to help OCR find small text in tab bar
      services.cage.program = pkgs.writeShellScript "firefox" ''
        ${getExe pkgs.wlr-randr} --output Virtual-1 --mode 1360x768 --scale 1.3
        exec firefox file://${pkgs.writeText pageFileName html}
      '';
    };
  enableOCR = true;
  testScript = ''
    @polling_condition
    def firefox_running():
      "check that firefox is running"
      # pgrep without -x because /proc/*/comm can be either "firefox" or ".firefox-wrappe", depending on the exact package used
      machine.succeed("pgrep firefox")

    machine.wait_for_unit("graphical.target")

    firefox_running.wait()
    with firefox_running:
      with subtest("1. Firefox renders the page body"):
        # give cage & Firefox some time to fully open
        machine.wait_for_text(${escapeNixString pageBody})

      # make screenshot after page is fully loaded to avoid black screenshots
      machine.screenshot("firefox-page")

      # further timeouts are shorter as page should be fully loaded by now

      with subtest("2. Firefox renders text in url bar"):
        machine.wait_for_text(${escapeNixString pageFileName}, timeout=20)

      with subtest("3. Firefox renders the page title in tab bar"):
        machine.wait_for_text(${escapeNixString pageTitle}, timeout=20)
  '';
}
