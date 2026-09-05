{ pkgs, ... }:
let
  pluginName = "DefaultTrackers";
  plugin = (
    pkgs.callPackage (
      { python3, fetchFromGitHub }:
      python3.pkgs.buildPythonPackage {
        name = "deluge-default-trackers";
        version = "v0.6";
        src = fetchFromGitHub {
          owner = "stefantalpalaru/";
          repo = "deluge-default-trackers";
          rev = "v0.6";
          sha256 = "sha256-4dii8OLobczEDXhD+TFUD2yCXHf1B4Ns51cRQJsGIvI=";
        };
        doCheck = false;
        format = "other";
        nativeBuildInputs = [ python3.pkgs.setuptools ];
        buildPhase = ''
          mkdir "$out"
          python3 setup.py bdist_egg
          cp dist/* "$out"
        '';
        doInstallPhase = false;
      }
    ) { }
  );
in
{
  name = "deluge";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    simple = {
      services.deluge = {
        enable = true;
        package = pkgs.deluge-2_x;
        web = {
          enable = true;
          openFirewall = true;
        };
      };
    };

    declarative = {
      services.deluge = {
        enable = true;
        package = pkgs.deluge-2_x;
        openFirewall = true;
        declarative = true;
        config = {
          allow_remote = true;
          download_location = "/var/lib/deluge/my-download";
          daemon_port = 58846;
          listen_ports = [
            6881
            6889
          ];
          enabled_plugins = [ pluginName ];
        };
        web = {
          enable = true;
          port = 3142;
        };
        authFile = pkgs.writeText "deluge-auth" ''
          localclient:a7bef72a890:10
          andrew:password:10
          user3:anotherpass:5
        '';
        additionalPlugins = [
          plugin
        ];
      };
    };

  };

  testScript = ''
    def deluge_console(node, cmd):
        out = node.succeed(f"deluge-console 'connect 127.0.0.1:58846 andrew password; {cmd}'")
        print(f"{cmd}:\n{out}")
        return out

    def parse_plugin(out):
        return [p.strip() for p in out.splitlines()[1:]]

    pluginName = "${pluginName}"

    start_all()

    simple.wait_for_unit("deluged")
    simple.wait_for_unit("delugeweb")
    simple.wait_for_open_port(8112)
    declarative.wait_for_unit("network.target")
    declarative.wait_until_succeeds("curl --fail http://simple:8112")

    declarative.wait_for_unit("deluged")
    declarative.wait_for_unit("delugeweb")
    declarative.wait_until_succeeds("curl --fail http://declarative:3142")

    deluge_console(declarative, "help")

    with subtest("Additional plugin found in available plugins list"):
        available_plugins = parse_plugin(deluge_console(declarative, "plugin --list"))
        if pluginName not in available_plugins:
           raise Exception(f"Expected {pluginName} to be in available plugins list: {", ".join(available_plugins)}")

    with subtest("Additional plugin found in enabled plugins list"):
        enabled_plugins = parse_plugin(deluge_console(declarative, "plugin --show"))
        if pluginName not in enabled_plugins:
           raise Exception(f"Expected {pluginName} to be in enabled plugins list: {", ".join(enabled_plugins)}")
  '';
}
