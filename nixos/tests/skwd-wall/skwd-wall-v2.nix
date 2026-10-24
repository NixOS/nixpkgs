{ pkgs, ... }:
let
  modelPath = "${pkgs.skwd-lens-model}/share/skwd-lens/models/semantic";
in
{
  name = "skwd-wall-v2";
  meta.maintainers = with pkgs.lib.maintainers; [
    HomieDerPrakti
    futurekismo
  ];

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      skwd-wall-v2
      skwd-lens
      skwd-lens-model
      skwd-deck
      skwd-paper-v2
      skwd-deck-steamworks
    ];
    users.users.tester = {
      isNormalUser = true;
      password = "";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    machine.succeed("skwd-wall-v2 --version")
    machine.succeed("skwd-walld --version")
    machine.succeed("skwd-paper-v2 --version")
    machine.succeed("skwd-lens --version")
    machine.succeed("skwd-helm --version")
    machine.succeed("skwd-steam --version")

    machine.succeed("test -d ${modelPath}")
    machine.succeed("test -f ${modelPath}/semantic-pack.json")
    machine.succeed("test -f ${modelPath}/runtime/libonnxruntime.so.1.27.0")
  '';
}
