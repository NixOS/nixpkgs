# This test runs rabbitmq and checks if rabbitmq is up and running.

import ./make-test-python.nix ({ pkgs, ... }:
let
  # in real life, you would keep this out of your repo and deploy it to a safe
  # location using safe means.
  configKeyPath = pkgs.writeText "fake-config-key" "hOjWzSEn2Z7cHzKOcf6i183O2NdjurSuoMDIIv01";
in
{
  name = "rabbitmq";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes.machine = {
    services.rabbitmq = {
      enable = true;
      managementPlugin.enable = true;

      # To encrypt:
      # rabbitmqctl --quiet encode --cipher blowfish_cfb64 --hash sha256 \
      #   --iterations 10000 '<<"dJT8isYu6t0Xb6u56rPglSj1vK51SlNVlXfwsRxw">>' \
      #   "hOjWzSEn2Z7cHzKOcf6i183O2NdjurSuoMDIIv01" ;
      config = ''
        [ { rabbit
          , [ {default_user, <<"alice">>}
            , { default_pass
              , {encrypted,<<"oKKxyTze9PYmsEfl6FG1MxIUhxY7WPQL7HBoMPRC/1ZOdOZbtr9+DxjWW3e1D5SL48n3D9QOsGD0cOgYG7Qdvb7Txrepw8w=">>}
              }
            , {config_entry_decoder
              , [ {passphrase, {file, <<"${configKeyPath}">>}}
                , {cipher, blowfish_cfb64}
                , {hash, sha256}
                , {iterations, 10000}
                ]
              }
            % , {rabbitmq_management, [{path_prefix, "/_queues"}]}
            ]
          }
        ].
      '';
    };
    # Ensure there is sufficient extra disk space for rabbitmq to be happy
    virtualisation.diskSize = 1024;
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("rabbitmq.service")
    machine.wait_until_succeeds(
        'su -s ${pkgs.runtimeShell} rabbitmq -c "rabbitmqctl status"'
    )
    machine.wait_for_open_port(15672)

    # The password is the plaintext that was encrypted with rabbitmqctl encode above.
    machine.wait_until_succeeds(
        '${pkgs.rabbitmq-java-client}/bin/PerfTest --time 10 --uri amqp://alice:dJT8isYu6t0Xb6u56rPglSj1vK51SlNVlXfwsRxw@localhost'
    )
  '';
})
