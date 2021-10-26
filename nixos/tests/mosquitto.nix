import ./make-test-python.nix ({ pkgs, lib, ... }:

let
  port = 1888;
  tlsPort = 1889;
  password = "VERY_secret";
  hashedPassword = "$7$101$/WJc4Mp+I+uYE9sR$o7z9rD1EYXHPwEP5GqQj6A7k4W1yVbePlb8TqNcuOLV9WNCiDgwHOB0JHC1WCtdkssqTBduBNUnUGd6kmZvDSw==";
  topic = "test/foo";

  snakeOil = pkgs.runCommand "snakeoil-certs" {
    buildInputs = [ pkgs.gnutls.bin ];
    caTemplate = pkgs.writeText "snakeoil-ca.template" ''
      cn = server
      expiration_days = -1
      cert_signing_key
      ca
    '';
    certTemplate = pkgs.writeText "snakeoil-cert.template" ''
      cn = server
      expiration_days = -1
      tls_www_server
      encryption_key
      signing_key
    '';
    userCertTemplate = pkgs.writeText "snakeoil-user-cert.template" ''
      organization = snakeoil
      cn = client1
      expiration_days = -1
      tls_www_client
      encryption_key
      signing_key
    '';
  } ''
    mkdir "$out"

    certtool -p --bits 2048 --outfile "$out/ca.key"
    certtool -s --template "$caTemplate" --load-privkey "$out/ca.key" \
                --outfile "$out/ca.crt"
    certtool -p --bits 2048 --outfile "$out/server.key"
    certtool -c --template "$certTemplate" \
                --load-ca-privkey "$out/ca.key" \
                --load-ca-certificate "$out/ca.crt" \
                --load-privkey "$out/server.key" \
                --outfile "$out/server.crt"

    certtool -p --bits 2048 --outfile "$out/client1.key"
    certtool -c --template "$userCertTemplate" \
                --load-privkey "$out/client1.key" \
                --load-ca-privkey "$out/ca.key" \
                --load-ca-certificate "$out/ca.crt" \
                --outfile "$out/client1.crt"
  '';

in {
  name = "mosquitto";
  meta = with pkgs.lib; {
    maintainers = with maintainers; [ pennae peterhoeg ];
  };

  nodes = let
    client = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ mosquitto ];
    };
  in {
    server = { pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ port tlsPort ];
      services.mosquitto = {
        enable = true;
        settings = {
          sys_interval = 1;
        };
        listeners = [
          {
            inherit port;
            users = {
              password_store = {
                inherit password;
              };
              password_file = {
                passwordFile = pkgs.writeText "mqtt-password" password;
              };
              hashed_store = {
                inherit hashedPassword;
              };
              hashed_file = {
                hashedPasswordFile = pkgs.writeText "mqtt-hashed-password" hashedPassword;
              };

              reader = {
                inherit password;
                acl = [
                  "read ${topic}"
                  "read $SYS/#" # so we always have something to read
                ];
              };
              writer = {
                inherit password;
                acl = [ "write ${topic}" ];
              };
            };
          }
          {
            port = tlsPort;
            users.client1 = {
              acl = [ "read $SYS/#" ];
            };
            settings = {
              cafile = "${snakeOil}/ca.crt";
              certfile = "${snakeOil}/server.crt";
              keyfile = "${snakeOil}/server.key";
              require_certificate = true;
              use_identity_as_username = true;
            };
          }
        ];
      };
    };

    client1 = client;
    client2 = client;
  };

  testScript = ''
    def mosquitto_cmd(binary, user, topic, port):
        return (
            "mosquitto_{} "
            "-V mqttv311 "
            "-h server "
            "-p {} "
            "-u {} "
            "-P '${password}' "
            "-t '{}'"
        ).format(binary, port, user, topic)


    def publish(args, user, topic="${topic}", port=${toString port}):
        return "{} {}".format(mosquitto_cmd("pub", user, topic, port), args)


    def subscribe(args, user, topic="${topic}", port=${toString port}):
        return "{} -C 1 {}".format(mosquitto_cmd("sub", user, topic, port), args)

    def parallel(*fns):
        from threading import Thread
        threads = [ Thread(target=fn) for fn in fns ]
        for t in threads: t.start()
        for t in threads: t.join()


    start_all()
    server.wait_for_unit("mosquitto.service")

    def check_passwords():
        client1.succeed(publish("-m test", "password_store"))
        client1.succeed(publish("-m test", "password_file"))
        client1.succeed(publish("-m test", "hashed_store"))
        client1.succeed(publish("-m test", "hashed_file"))

    check_passwords()

    def check_acl():
        client1.succeed(subscribe("", "reader", topic="$SYS/#"))
        client1.fail(subscribe("-W 5", "writer", topic="$SYS/#"))

        parallel(
            lambda: client1.succeed(subscribe("-i 3688cdd7-aa07-42a4-be22-cb9352917e40", "reader")),
            lambda: [
                server.wait_for_console_text("3688cdd7-aa07-42a4-be22-cb9352917e40"),
                client2.succeed(publish("-m test", "writer"))
            ])

        parallel(
            lambda: client1.fail(subscribe("-W 5 -i 24ff16a2-ae33-4a51-9098-1b417153c712", "reader")),
            lambda: [
                server.wait_for_console_text("24ff16a2-ae33-4a51-9098-1b417153c712"),
                client2.succeed(publish("-m test", "reader"))
            ])

    check_acl()

    def check_tls():
        client1.succeed(
            subscribe(
                "--cafile ${snakeOil}/ca.crt "
                "--cert ${snakeOil}/client1.crt "
                "--key ${snakeOil}/client1.key",
                topic="$SYS/#",
                port=${toString tlsPort},
                user="no_such_user"))

    check_tls()
  '';
})
