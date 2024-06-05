{ lib
, ...
}:

{
  name = "lprint";
  meta = with lib.maintainers; {
    maintainers = [ pandapip1 ];
  };

  nodes = {
    machine = { ... }: {
      services.printing.lprint = {
        enable = true;
      };
    };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("lprint.service")
  '';
}
