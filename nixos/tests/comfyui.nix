{
  pkgs,
  ...
}:
let
  # Fake model: local derivation via a file:// URL (must not fetchurl a real large model in CI).
  fakeModel = pkgs.runCommand "fake-model" { } ''
    mkdir -p $out
    echo "fake checkpoint" > $out/fake-checkpoint.safetensors
  '';
  fakeModelUrl = "file://${fakeModel}/fake-checkpoint.safetensors";
  fakeModelHash = "sha256-cYVCuccIZ3xo9vdsOvUA+i+SeXHj2Na9lX5p+cGgvus=";
in
{
  name = "comfyui";
  meta.maintainers = pkgs.comfyui.meta.maintainers;

  nodes.machine = { ... }: {
    services.comfyui = {
      enable = true;
      # VM has no GPU: CPU mode (ComfyUI aborts on CUDA detection failure without --cpu).
      acceleration = "cpu";
      # flask is not in ComfyUI's appDependencies: proves the extraPackages injection.
      extraPackages = ps: [ ps.flask ];
      models = [
        {
          name = "fake-checkpoint.safetensors";
          url = fakeModelUrl;
          hash = fakeModelHash;
          installPaths = [ "checkpoints" ];
        }
      ];
    };
  };

  testScript =
    { nodes, ... }:
    let
      # The module exposes the fully overridden package (extraPackages, cudaSupport)
      # via `services.comfyui.finalPackage`; read its pythonEnv to inspect it.
      pythonEnv = nodes.machine.services.comfyui.finalPackage.pythonEnv;
    in
    ''
      start_all()
      machine.wait_for_unit("comfyui.service")
      machine.wait_for_open_port(8188)

      # extraPackages injects flask into ComfyUI's Python environment
      machine.succeed("${pythonEnv}/bin/python -c 'import flask'")

      # Model symlink points into /nix/store
      machine.succeed("readlink -f /var/lib/comfyui/models/checkpoints/fake-checkpoint.safetensors | grep -q '^/nix/store'")

      # Non-declarative coexistence: manually drop a file, restart (preStart re-runs),
      # it survives and the declarative symlink is rebuilt.
      machine.succeed("echo manual > /var/lib/comfyui/models/checkpoints/manual.safetensors")
      machine.systemctl("restart", "comfyui")
      machine.wait_for_open_port(8188)
      machine.succeed("test -f /var/lib/comfyui/models/checkpoints/manual.safetensors")
      machine.succeed("readlink -f /var/lib/comfyui/models/checkpoints/fake-checkpoint.safetensors | grep -q '^/nix/store'")
    '';
}
