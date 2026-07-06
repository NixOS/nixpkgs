{ pkgs, ... }:
{
  name = "e57inspector";
  meta.maintainers = with pkgs.lib.maintainers; [
    nh2
    chpatrick
  ];

  nodes.machine =
    { ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      services.xserver.enable = true;
      environment.systemPackages = [
        pkgs.e57inspector
        pkgs.xdotool
      ];
    };

  testScript =
    let
      testFile = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/asmaloney/libE57Format-test-data/bbcacec05d60f923869545c5eab33d94c390d50e/self/ColouredCubeFloat.e57";
        hash = "sha256-bb95crNYvX3Qhkx4k6Sqe2GjOf1u4nxxswMfdjyXfTM=";
      };
    in
    ''
      start_all()
      machine.wait_for_x()

      machine.execute("e57inspector ${testFile} >&2 &")
      machine.wait_until_succeeds("xdotool search --pid $(pidof .e57inspector-wrapped)")
      machine.screenshot("screen")
    '';
}
