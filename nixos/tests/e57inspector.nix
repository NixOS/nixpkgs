{ pkgs, runTest }:
let
  testFile = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/asmaloney/libE57Format-test-data/bbcacec05d60f923869545c5eab33d94c390d50e/self/ColouredCubeFloat.e57";
    hash = "sha256-bb95crNYvX3Qhkx4k6Sqe2GjOf1u4nxxswMfdjyXfTM=";
  };

  vmTest = runTest {
    name = "e57inspector-vm";
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
        ];
      };
    enableOCR = true;

    testScript = ''
      start_all()
      machine.wait_for_x()

      machine.execute("e57inspector ${testFile} >&2 &")
      machine.wait_for_text("File")  # menu visible

      machine.screenshot("screen.png")
    '';
  };
in
{
  vm = vmTest;

  screenshot-analysis = pkgs.callPackage ./vlm-screenshot-question.nix {
    name = "e57inspector-screenshot-analysis";
    screenshot = "${vmTest}/screen.png";
    question = ''
      Look at this screenshot of a desktop application.
      Answer: Does the application show that a file was loaded into it successfully?
      For this, only scans matter, as there are no images in the file.
      The inspector on the left should show child elements below 'Data 3D'.
    '';
  };
}
