import ./make-test-python.nix ({ pkgs, lib, ...}:

with lib;

{
  name = "couchdb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ fpletz ];
  };

  nodes = {
    couchdb1 =
      { pkgs, ... }:

      { environment.systemPackages = with pkgs; [ jq ];
        services.couchdb.enable = true;
      };

    couchdb2 =
      { pkgs, ... }:

      { environment.systemPackages = with pkgs; [ jq ];
        services.couchdb.enable = true;
        services.couchdb.package = pkgs.couchdb2;
      };
  };

  testScript = let
    curlJqCheck = action: path: jqexpr: result:
      pkgs.writeScript "curl-jq-check-${action}-${path}.sh" ''
        RESULT=$(curl -X ${action} http://127.0.0.1:5984/${path} | jq -r '${jqexpr}')
        echo $RESULT >&2
        if [ "$RESULT" != "${result}" ]; then
          exit 1
        fi
      '';
  in ''
    start_all()

    couchdb1.wait_for_unit("couchdb.service")
    couchdb1.wait_until_succeeds(
        "${curlJqCheck "GET" "" ".couchdb" "Welcome"}"
    )
    couchdb1.wait_until_succeeds(
        "${curlJqCheck "GET" "_all_dbs" ". | length" "2"}"
    )
    couchdb1.succeed("${curlJqCheck "PUT" "foo" ".ok" "true"}")
    couchdb1.succeed(
        "${curlJqCheck "GET" "_all_dbs" ". | length" "3"}"
    )
    couchdb1.succeed(
        "${curlJqCheck "DELETE" "foo" ".ok" "true"}"
    )
    couchdb1.succeed(
        "${curlJqCheck "GET" "_all_dbs" ". | length" "2"}"
    )

    couchdb2.wait_for_unit("couchdb.service")
    couchdb2.wait_until_succeeds(
        "${curlJqCheck "GET" "" ".couchdb" "Welcome"}"
    )
    couchdb2.wait_until_succeeds(
        "${curlJqCheck "GET" "_all_dbs" ". | length" "0"}"
    )
    couchdb2.succeed("${curlJqCheck "PUT" "foo" ".ok" "true"}")
    couchdb2.succeed(
        "${curlJqCheck "GET" "_all_dbs" ". | length" "1"}"
    )
    couchdb2.succeed(
        "${curlJqCheck "DELETE" "foo" ".ok" "true"}"
    )
    couchdb2.succeed(
        "${curlJqCheck "GET" "_all_dbs" ". | length" "0"}"
    )
  '';
})
