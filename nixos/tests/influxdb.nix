# This test runs influxdb and checks if influxdb is up and running

import ./make-test.nix {
  nodes = {
    one = { config, pkgs, ... }: {
      services.influxdb.enable = true;
    };
  };

  testScript = ''
    startAll;
  
    $one->waitForUnit("influxdb.service");

    # Check if admin interface is avalible
    $one->waitUntilSucceeds("curl -f 127.0.0.1:8083");

    # create database
    $one->succeed(q~
      curl -X POST 'http://localhost:8086/db?u=root&p=root' \
        -d '{"name": "test"}'
    ~);

    # write some points and run simple query
    $one->succeed(q~
      curl -X POST 'http://localhost:8086/db/test/series?u=root&p=root' \
        -d '[{"name":"foo","columns":["val"],"points":[[6666]]}]'
    ~);
    $one->succeed(q~
      curl -G 'http://localhost:8086/db/test/series?u=root&p=root' \
        --data-urlencode 'q=select * from foo limit 1' | grep 6666
    ~);
  '';
}
