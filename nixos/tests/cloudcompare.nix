{ pkgs, runTest }:
let
  testFile = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/asmaloney/libE57Format-test-data/bbcacec05d60f923869545c5eab33d94c390d50e/self/ColouredCubeFloat.e57";
    hash = "sha256-bb95crNYvX3Qhkx4k6Sqe2GjOf1u4nxxswMfdjyXfTM=";
  };

  vmTest = runTest {
    name = "cloudcompare-vm";
    meta.maintainers = with pkgs.lib.maintainers; [
      nh2
    ];

    enableOCR = true;

    nodes.machine =
      { ... }:
      {
        imports = [
          ./common/x11.nix
        ];

        services.xserver.enable = true;
        environment.systemPackages = [
          pkgs.cloudcompare
        ];
      };

    testScript = ''
      start_all()
      machine.wait_for_x()

      machine.execute("CloudCompare ${testFile} >&2 &")
      machine.wait_for_window("CloudCompare")

      # Wait for the file to be loaded; CloudCompare shows "loaded successfully" in its log panel at the bottom.
      machine.wait_for_text("loaded successfully")

      machine.screenshot("screen.png")
    '';
  };
in
{
  vm = vmTest;

  screenshot-analysis = pkgs.callPackage ./vlm-screenshot-question.nix {
    name = "cloudcompare-screenshot-analysis";
    screenshot = "${vmTest}/screen.png";
    question = ''
      Look at this screenshot of a desktop application.
      Answer: Does the application show a 3D point cloud viewer (CloudCompare) that has successfully loaded and is displaying a coloured point cloud?
      Evidence of success: a 3D viewport with coloured points is visible AND there are no error dialogs or error messages.
    '';
  };
}
