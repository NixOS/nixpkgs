import ./make-test-python.nix ({ lib, ... }: {
  name = "user-group-membership";
  meta = with lib.maintainers; { maintainers = [ bjornfor ]; };

  nodes =
    let
      commonConfig = {
        users.users.alice = {
          isNormalUser = true;
        };
        users.users.bob = {
          isNormalUser = true;
          group = "users";
        };
      };
    in
      {
        shared = {
          imports = [ commonConfig ];
          users.solitaryByDefault = false;
        };
        solitary = {
          imports = [ commonConfig ];
          users.solitaryByDefault = true;
        };
      };

  testScript = ''
    start_all()

    with subtest("solitaryByDefault = false"):
        shared.succeed('[ "$(stat -c %G /home/alice)" == "users" ]')
        shared.succeed('[ "$(stat -c %G /home/bob)" == "users" ]')

    with subtest("solitaryByDefault = true"):
        solitary.succeed('[ "$(stat -c %G /home/alice)" == "alice" ]')
        solitary.succeed('[ "$(stat -c %G /home/bob)" == "users" ]')
  '';
})
