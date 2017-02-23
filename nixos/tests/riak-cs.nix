import ./make-test.nix {
  name = "riak";

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.riak = {
          enable = true;
          package = pkgs.riak;
          nodeName = "riak@127.0.0.1";
          extraConfig = ''
            buckets.default.allow_mult = true
            listener.protobuf.internal = 127.0.0.1:8087;
            erlang.max_ports = 65536
          '';
          # Necessary to get Riak working with Riak CS
          extraAdvancedConfig = ''
                [
                  {eleveldb, [
                    {total_leveldb_mem_percent, 30}
                  ]},
                  {riak_kv, [
                  %% Other configs
                     {add_paths, ["${pkgs.riak-cs}/lib/riak_cs-2.1.1/ebin"]},
                     {storage_backend, riak_cs_kv_multi_backend},
                     {multi_backend_prefix_list, [{<<"0b:">>, be_blocks}]},
                     {multi_backend_default, be_default},
                     {multi_backend, [
                       {be_default, riak_kv_eleveldb_backend, [
                       {data_root, "/var/lib/riak/leveldb"}
                     ]},
                     {be_blocks, riak_kv_bitcask_backend, [
                     {data_root, "/var/lib/riak/bitcask"}
                   ]}
                 ]}
                 %% Other configs
               ]}
             ].
          '';
        };

        services.stanchion = {
          enable = true;
          nodeName = "stanchion@127.0.0.1";
          riakHost = "127.0.0.1:8087";
          listener = "127.0.0.1:8085";
        };

        services.riak-cs = {
          enable = true;
          package = pkgs.riak-cs;
          nodeName = "riak-cs@127.0.0.1";
          stanchionSsl = false;
          stanchionHost = "127.0.0.1:8085";
          riakHost = "127.0.0.1:8087";
          listener = "127.0.0.1:8080";
          anonymousUserCreation = true; # So we don't need to supply our own admin keys/passwords
        };
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("riak");
    $master->sleep(20); # Hopefully this is long enough!!

    $master->waitForUnit("stanchion");
    $master->sleep(20);

    $master->waitForUnit("riak-cs");
    $master->sleep(20);

    $master->succeed("riak-cs ping 2>&1");
  '';
}
