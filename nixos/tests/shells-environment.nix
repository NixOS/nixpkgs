let
  myJson = ''{ "key": "my super \n\"quirky\"\n value" }'';
in
{
  name = "shells-environment";

  nodes.machine = {
    environment.variables = {
      MY_JSON = myJson;
    };
  };

  testScript = ''
    machine.succeed(r"""[ "$MY_JSON" = '${myJson}' ]""")
  '';
}
