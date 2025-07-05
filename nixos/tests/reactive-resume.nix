{ lib, ... }:
let
  nodeName = "machine";
in
{
  name = "reactive-resume";

  nodes.${nodeName}.services.reactive-resume.enable = true;

  testScript = ''
    start_all()
    ${nodeName}.wait_for_unit("reactive-resume")
  '';

  meta.maintainers = with lib.maintainers; [ l0b0 ];
}
