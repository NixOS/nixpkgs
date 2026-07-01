{
  name = "nginx-dynamic-modules";

  nodes.machine =
    { pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        # echo is built dynamically (--add-dynamic-module) and loaded via load_module.
        additionalModules = [ (pkgs.nginxModules.echo // { dynamic = true; }) ];
        virtualHosts."localhost".locations."/".extraConfig = ''
          echo "dynamic-module-ok";
        '';
      };
    };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.nginx;
    in
    ''
      machine.wait_for_unit("nginx")
      machine.wait_for_open_port(80)

      # The module was built as a loadable object and a load_module snippet generated.
      machine.succeed("ls ${cfg.package}/modules/*.so")
      machine.succeed("grep -F load_module ${cfg.package}/etc/nginx/dynamic-modules.conf")

      # The echo directive only exists if the .so was actually dlopen'd into the master.
      response = machine.wait_until_succeeds("curl -fsS http://127.0.0.1/")
      assert "dynamic-module-ok" in response, response
    '';
}
