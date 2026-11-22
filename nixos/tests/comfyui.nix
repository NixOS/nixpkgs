{
  pkgs,
  ...
}:

let
  # A directory-style custom node with a Python dependency that is not part of
  # ComfyUI's own appDependencies.  This exercises the pythonDeps contract
  # without pretending that a fake node is a real upstream package.
  testNode = pkgs.buildComfyUICustomNode {
    pname = "comfyui-test-node";
    version = "0";

    src = pkgs.runCommand "comfyui-test-node-src" { } ''
      mkdir -p $out
      cat > $out/__init__.py <<'EOF'
      import toml

      NODE_CLASS_MAPPINGS = { }
      NODE_DISPLAY_NAME_MAPPINGS = { }
      EOF
    '';

    pythonDeps = ps: [ ps.toml ];
  };
in
{
  name = "comfyui";
  meta.maintainers = with pkgs.lib.maintainers; [ knightfemale ];

  nodes.machine = {
    services.comfyui = {
      enable = true;
      extraArgs = [ "--cpu" ];
      customNodes = [
        pkgs.comfyui-custom-nodes.comfyui-crystools
        testNode
      ];
    };

    virtualisation = {
      cores = 2;
      memorySize = 4096;
    };
  };

  testScript =
    { nodes, ... }:
    let
      pythonEnv = nodes.machine.services.comfyui.finalPackage.pythonEnv;
    in
    ''
      start_all()
      machine.wait_for_unit("comfyui.service")
      machine.wait_for_open_port(8188)

      # Nodes are linked from the store, not copied into the mutable data directory.
      machine.succeed("test -L /var/lib/comfyui/custom_nodes/ComfyUI-Crystools")
      machine.succeed("readlink -f /var/lib/comfyui/custom_nodes/ComfyUI-Crystools | grep -q '^/nix/store'")
      machine.succeed("test -f /var/lib/comfyui/custom_nodes/ComfyUI-Crystools/__init__.py")
      machine.succeed("test -L /var/lib/comfyui/custom_nodes/comfyui-test-node")

      # pythonDeps from real and synthetic custom node packages are merged into
      # ComfyUI's Python env.
      machine.succeed("${pythonEnv}/bin/python -c 'import deepdiff, piexif, cpuinfo'")
      machine.succeed("${pythonEnv}/bin/python -c 'import toml'")

      # The real node is actually discovered by ComfyUI, not just present on disk.
      machine.wait_until_succeeds(
        "${pkgs.curl}/bin/curl -fsS http://127.0.0.1:8188/object_info | ${pkgs.gnugrep}/bin/grep -q 'Crystools'"
      )

      # Manually installed nodes survive a restart; the declarative links are rebuilt.
      machine.succeed("mkdir -p /var/lib/comfyui/custom_nodes/Manual")
      machine.succeed("echo manual > /var/lib/comfyui/custom_nodes/Manual/manual.txt")
      machine.systemctl("restart", "comfyui")
      machine.wait_for_unit("comfyui.service")
      machine.wait_for_open_port(8188)
      machine.succeed("test -f /var/lib/comfyui/custom_nodes/Manual/manual.txt")
      machine.succeed("test -L /var/lib/comfyui/custom_nodes/ComfyUI-Crystools")
    '';
}
