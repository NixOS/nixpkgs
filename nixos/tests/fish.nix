{
  name = "fish";

  nodes.machine =
    { pkgs, ... }:

    {
      programs.fish.enable = true;
      environment.systemPackages = with pkgs; [
        coreutils
        procps # kill collides with coreutils' to test https://github.com/NixOS/nixpkgs/issues/56432
      ];

      # Avoid slow man cache build
      documentation.man.enable = false;
    };

  testScript =
    #python
    ''
      start_all()
      machine.wait_for_file("/etc/fish/generated_completions/coreutils.fish")
      machine.wait_for_file("/etc/fish/generated_completions/kill.fish")
      machine.succeed(
          "fish -ic 'echo $fish_complete_path' | grep -q '/share/fish/vendor_completions.d /etc/fish/generated_completions /root/.cache/fish/generated_completions$'"
      )
      machine.wait_for_file("/etc/fish/config.fish")
      config = machine.succeed("fish_indent -c /etc/fish/config.fish")
    '';
}
