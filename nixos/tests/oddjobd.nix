import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "oddjobd";
  meta.maintainers = [ lib.maintainers.anthonyroussel ];

  nodes.machine = { ... } : {
    environment.systemPackages = [
      pkgs.oddjob
    ];

    programs.oddjobd.enable = true;
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("oddjobd.service")
    machine.wait_for_file("/run/oddjobd.pid")

    with subtest("send oddjob listall request"):
      result = machine.succeed("oddjob_request -s com.redhat.oddjob -o /com/redhat/oddjob -i com.redhat.oddjob listall")
      assert ('(service="com.redhat.oddjob",object="/com/redhat/oddjob",interface="com.redhat.oddjob",method="listall")' in result)
  '';
})
