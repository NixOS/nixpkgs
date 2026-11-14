{ pkgs, ... }:

let
  # Verify that Serve waits for backend readiness before applying its configuration.
  # Mock the CLI to control the backend state without overriding the service under test.
  tailscaleCli = pkgs.writeShellScriptBin "tailscale" ''
    if [[ "$1" == status ]]; then
      if [[ -e /run/backend-ready ]]; then
        state=Running
      else
        state=NoState
        touch /run/status-checked
      fi
      printf '{"BackendState":"%s"}\n' "$state"
    else
      touch /run/serve-configured
    fi
  '';
  tailscaleTestPackage = pkgs.symlinkJoin {
    name = "tailscale-test";
    paths = [ pkgs.tailscale ];
    postBuild = ''
      rm $out/bin/tailscale
      ln -s ${tailscaleCli}/bin/tailscale $out/bin/tailscale
    '';
    meta.mainProgram = "tailscale";
  };
in
{
  name = "tailscale-serve";

  nodes.machine = {
    services.tailscale = {
      enable = true;
      disableUpstreamLogging = true;
      package = tailscaleTestPackage;
      serve.enable = true;
      serve.services.test.endpoints."tcp:80" = "http://127.0.0.1:8080";
    };
  };

  testScript = ''
    machine.wait_until_succeeds("test -e /run/status-checked")
    machine.succeed("test ! -e /run/serve-configured")
    machine.succeed("touch /run/backend-ready")
    machine.wait_for_unit("tailscale-serve.service")
    machine.succeed("test -e /run/serve-configured")
  '';
}
