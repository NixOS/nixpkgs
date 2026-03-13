{ lib, ... }:
{
  name = "docuseal";
  meta.maintainers = with lib.maintainers; [
    etu
    stunkymonkey
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.docuseal = {
        enable = true;
        port = 80;
        secretKeyBaseFile = pkgs.writeText "secret" "23bec595a1658d136d532af1365b40024b662c0862e9cdf14fd22c0afaeb0dd6322b114fa35bd82e564bae44a896b5abef3a66afd61e1382b8ebd579e2c5c17f";
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("docuseal.service")
    machine.wait_for_open_port(80)
    response = machine.succeed("curl -vvv -s -H 'Host: docuseal' http://127.0.0.1:80/setup")
    assert "<title>\n  DocuSeal | Open Source Document Signing\n</title>" in response, "page didn't load successfully"
  '';
}
