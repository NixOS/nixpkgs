let
  makeNode =
    couchpkg: user: passwd:
    { pkgs, ... }:

    {
      environment.systemPackages = [ pkgs.jq ];
      services.couchdb.enable = true;
      services.couchdb.package = couchpkg;
      services.couchdb.adminUser = user;
      services.couchdb.adminPass = passwd;
    };
  testuser = "testadmin";
  testpass = "cowabunga";
  testlogin = "${testuser}:${testpass}@";
in
import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "couchdb";
    meta.maintainers = [ ];

    nodes = {
      couchdb3 = makeNode pkgs.couchdb3 testuser testpass;
    };

    testScript =
      let
        curlJqCheck =
          login: action: path: jqexpr: result:
          pkgs.writeScript "curl-jq-check-${action}-${path}.sh" ''
            RESULT=$(curl -X ${action} http://${login}127.0.0.1:5984/${path} | jq -r '${jqexpr}')
            echo $RESULT >&2
            if [ "$RESULT" != "${result}" ]; then
              exit 1
            fi
          '';
      in
      ''
        start_all()

        couchdb3.wait_for_unit("couchdb.service")
        couchdb3.wait_until_succeeds(
            "${curlJqCheck testlogin "GET" "" ".couchdb" "Welcome"}"
        )
        couchdb3.wait_until_succeeds(
            "${curlJqCheck testlogin "GET" "_all_dbs" ". | length" "0"}"
        )
        couchdb3.succeed("${curlJqCheck testlogin "PUT" "foo" ".ok" "true"}")
        couchdb3.succeed(
            "${curlJqCheck testlogin "GET" "_all_dbs" ". | length" "1"}"
        )
        couchdb3.succeed(
            "${curlJqCheck testlogin "DELETE" "foo" ".ok" "true"}"
        )
        couchdb3.succeed(
            "${curlJqCheck testlogin "GET" "_all_dbs" ". | length" "0"}"
        )
        couchdb3.succeed(
            "${curlJqCheck testlogin "GET" "_node/couchdb@127.0.0.1" ".couchdb" "Welcome"}"
        )
      '';
  }
)
