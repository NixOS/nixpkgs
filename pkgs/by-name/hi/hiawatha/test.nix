{
  lib,
  stdenvNoCC,
  hiawatha,
  curl,
  mbedtls,
  enableTls,
}:

stdenvNoCC.mkDerivation {
  name = "hiawatha-test";

  nativeBuildInputs = [
    hiawatha
    curl
  ] ++ lib.optional enableTls mbedtls;

  env = {
    inherit enableTls;
  };

  buildCommand = ''
    cp -r --no-preserve=mode ${hiawatha}/etc/hiawatha config
    sed "1i set TEST_DIR = $(pwd)" $serverConfigPath > config/hiawatha.conf

    mkdir www
    echo "it works" > www/index.html

    if [ -n "$enableTls" ]; then
      echo "Generating self-signed certificate"
      gen_key type=ec filename=server.key
      cert_write selfsign=1 issuer_key=server.key output_file=server.crt
      cat server.crt server.key > config/server.crt
    fi

    echo "Checking server configuration"
    hiawatha -c ./config -k

    echo "Starting server"
    hiawatha -c ./config

    testUrl() {
      echo "Testing $1"
      curl --verbose --insecure --fail "$1" | tee response
      grep -q "it works" response
    }

    testUrl http://127.0.0.1:8000
    if [ -n "$enableTls" ]; then
      testUrl https://127.0.0.1:8443
    fi

    touch $out
  '';

  serverConfig = ''
    # By default the server uses read-only directories like /var/lib and /etc
    WorkDirectory = TEST_DIR
    PIDfile = TEST_DIR/hiawatha.pid
    SystemLogfile = TEST_DIR/system.log
    GarbageLogfile = TEST_DIR/garbage.log
    ExploitLogfile = TEST_DIR/exploit.log
    AccessLogfile = TEST_DIR/access.log
    ErrorLogfile = TEST_DIR/error.log

    Binding {
      Interface = 127.0.0.1
      Port = 8000
    }

    ${lib.optionalString enableTls ''
      Binding {
        Interface = 127.0.0.1
        Port = 8443
        TLScertFile = TEST_DIR/config/server.crt
      }
    ''}

    Hostname = 127.0.0.1
    WebsiteRoot = TEST_DIR/www
    StartFile = index.html
  '';

  passAsFile = [ "serverConfig" ];
}
