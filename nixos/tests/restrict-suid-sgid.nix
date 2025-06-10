{ lib, ... }:
{
  name = "restrict-suid-sgid";
  meta.maintainers = with lib.maintainers; [ grimmauld ];

  nodes.machine = {
    security.restrict-suid-sgid.enable = true;
  };
  testScript = ''
    import json
    allowed = ["suid-sgid-wrappers.service", "systemd-tmpfiles-resetup.service", "systemd-tmpfiles-setup.service"];
    machine.wait_for_unit("default.target")

    output = machine.succeed("systemctl list-units -o json -t service --no-pager --all")
    for unit in json.loads(output):
      if unit["load"] != "loaded":
        continue
      with subtest(unit["unit"]):
        security_json = machine.succeed(f"systemd-analyze security {unit["unit"]} --json=short --no-pager")
        for property in json.loads(security_json):
          if property["name"] == "RestrictSUIDSGID":
            assert (not property["set"]) if unit["unit"] in allowed else property["set"]
  '';
}
