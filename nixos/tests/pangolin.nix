{
  lib,
  ...
}:
let
  # cannot use .test, since traefik catches that
  domain = "nixos.eu";
in
{
  # This test is a basic one, the true test is quite complicated and
  # is still under active development. It is currently held up by upstream,
  # and will be pushed along with the refactor
  name = "pangolin";
  meta.maintainers = with lib.maintainers; [
    jackr
    sigmasquadron
  ];

  nodes = {
    VPS = {
      environment = {
        etc = {
          "nixos/secrets/pangolin.env".text = ''
            SERVER_SECRET=fakefake
          '';
        };
      };
      services.pangolin = {
        enable = true;
        baseDomain = domain;
        letsEncryptEmail = "pangolin@${domain}";
        openFirewall = true;
        pangolinEnvironmentFile = "/etc/nixos/secrets/pangolin.env";
      };
    };
  };
  testScript = ''
    VPS.start()

    with subtest("start pangolin}"):
      VPS.wait_for_unit("pangolin.service")
      VPS.wait_for_open_port("3002")

    with subtest("start gerbil}"):
      VPS.wait_for_unit("gerbil.service")
      VPS.wait_for_open_port("3003")

    with subtest("start traefik}"):
      VPS.wait_for_unit("traefik.service")
  '';
}
