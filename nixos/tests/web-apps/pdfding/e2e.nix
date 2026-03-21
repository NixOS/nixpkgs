{
  lib,
  pkgs,
  ...
}:
{
  name = "PdfDing e2e tests";

  nodes = {
    machine =
      { ... }:
      {
        environment.systemPackages = [
          (pkgs.writeShellScriptBin "tests_e2e" (
            let
              pythonPath =
                with pkgs.python3Packages;
                [
                  playwright
                  pkgs.pdfding
                ]
                ++ pkgs.pdfding.dependencies
                ++ pkgs.pdfding.optional-dependencies.e2e;
            in
            # bash
            ''
              export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
              export PYTHONPATH=${pkgs.python3Packages.makePythonPath pythonPath}
              export PATH=${pkgs.pdfding.python}/bin:$PATH
              export E2E_TESTS=1
              cd $(mktemp -d)
              cp -r --no-preserve=all ${pkgs.pdfding.src} source
              cd source
              cp -ru --no-preserve=all ${pkgs.pdfding.frontend}/pdfding/static pdfding
              # some tests are flaky due to timeouts, re-run them
              python -m pytest pdfding/e2e \
                -x -r aR \
                --reruns 10 --only-rerun TimeoutError
            ''
            # see https://github.com/MrBin99/django-vite/issues/95
            # tdlr; collectstatic is not important for e2e tests which uses StaticLiveServerTestCase
            # it only cares about files in static/
          ))
        ];
      };
  };

  testScript =
    { nodes, ... }:
    # py
    ''
      # start
      start_all()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("tests_e2e | systemd-cat")
    '';

  # Debug interactively with:
  # - nix run .#nixosTests.pdfding.e2e.driverInteractive -L
  # - start_all() / run_tests()
  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock%3
  interactive.nodes.machine =
    { config, ... }:
    {
      imports = [
        # enable graphical session + users (alice, bob)
        ./common/x11.nix
        ./common/user-account.nix
      ];
      services.xserver.enable = true;
      test-support.displayManager.auto.user = "alice";
      virtualisation.memorySize = lib.mkForce 8192;
      environment.systemPackages = with pkgs; [
        htop
      ];
      # env DISPLAY=:0 sudo -u alice tests_e2e | systemd-cat
    };

  meta.maintainers = lib.teams.ngi.members;
}
