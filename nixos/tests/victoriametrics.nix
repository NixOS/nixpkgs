# This test runs influxdb and checks if influxdb is up and running

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "victoriametrics";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ yorickvp ];
  };

  nodes = {
    one = { ... }: {
      services.victoriametrics.enable = true;
    };
  };

  testScript = ''
    start_all()

    one.wait_for_unit("victoriametrics.service")

    # write some points and run simple query
    out = one.succeed(
        "curl -d 'measurement,tag1=value1,tag2=value2 field1=123,field2=1.23' -X POST 'http://localhost:8428/write'"
    )
    cmd = """curl -s -G 'http://localhost:8428/api/v1/export' -d 'match={__name__!=""}'"""
    # data takes a while to appear
    one.wait_until_succeeds(f"[[ $({cmd} | wc -l) -ne 0 ]]")
    out = one.succeed(cmd)
    assert '"values":[123]' in out
    assert '"values":[1.23]' in out
  '';
})
