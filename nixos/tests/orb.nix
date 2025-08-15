{ lib, ... }:

{
  name = "orb";
  meta.maintainers = with lib.maintainers; [
    gepbird
  ];

  nodes.machine =
    { ... }:
    {
      services.orb = {
        enable = true;
      };
    };

  testScript = ''
    # TODO: can this be done offline?
  '';
}
