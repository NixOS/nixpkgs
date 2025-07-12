{ ... }:
{
  name = "wallabag";

  nodes = {
    # test0 = { pkgs, ... }:
    #   {
    #     services.kanboard = {
    #       enable = true;
    #     };
    #   };
    machine = { pkgs, ... }:
    {
      services.wallabag = {
        enable = true;

        nginx = { };
      };
    };
  };
  testScript = ''
    start_all()

    # test0.systemctl("start network-online.target")
    # test0.wait_for_open_port(8000)

    machine.systemctl("start network-online.target")
    machine.wait_for_open_port(8000)
  '';
}
