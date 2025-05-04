{ lib, ... }:
let
  clientNodeName = "client";
in
{
  name = "tzupdate";

  # TODO: Test properly:
  # - Add server node
  # - Add client configuration to talk to the server node
  # - Assert that the time zone changes appropriately
  nodes.${clientNodeName} = {
    services.tzupdate.enable = true;
  };

  testScript = ''
    start_all()
    ${clientNodeName}.wait_for_unit("multi-user.target")
  '';

  meta.maintainers = [ lib.maintainers.l0b0 ];
}
