{ lib, ... }:
{
  name = "bookorbit";

  containers.machine = {
    services.bookorbit = {
      enable = true;
      environment = {
        JWT_SECRET = "abcdefghijklmnop";
        SETUP_BOOTSTRAP_TOKEN = "abcdefgh";
      };
    };
  };

  testScript =
    let
      baseUrl = "http://localhost:3000";
      username = "admin";
      password = "Sup3rSecret";
      jsonArg = value: "'${lib.escape [ "\"" "'" ] (builtins.toJSON value)}'";

      # Minimal valid EPUB (zip container), generated once and embedded so the test
      # needs no extra tooling inside the VM.
      sampleEpub = "UEsDBBQAAAAIAAdMT11vYassFgAAABQAAAAIAAAAbWltZXR5cGVLLCjIyUxOLMnMz9NPLShN0q7KLAAAUEsDBBQAAAAIAAdMT10dMgM2nwAAAOIAAAAWAAAATUVUQS1JTkYvY29udGFpbmVyLnhtbFWOQQ7CIBRE9z0FYWtadEuAJiauNfEEX/qrROAToEZvL7qocTfJzLwZNT6DZw/MxVHUfDds+Wg6ZSlWcBHzv8VaOBbNlxwlQXFFRghYZLWSEsaJ7BIwVvmNyRXCTceYykR1dh6LWSWbF+/7BPWm+fGwP53Fp9MIA6WZs4CTg76+EmoOKXlnobYvgvCSSqvZO1xx08a4MEr8+J0S67Z5A1BLAwQUAAAACAAHTE9d2LtPxh4BAADnAQAAEQAAAE9FQlBTL2NvbnRlbnQub3BmRdHBbsMgDADQe78CcZ0S2u2wKUqo1MOO22HdB9DgJFYJsMS02d+PkiW5gWw/Y1Mep96wGwwjOlvxQ77nDGztNNq24t/n9+yNH+Wu9Kq+qhZYzLZjxTsiXwhxv99z1L7J3dCK5/3+VTjf8I17eXDB4k+ADDVYwgZhqPjFuStqLneMlT2Q0orUTBe6XnUfBpNkXQsw0Mf6URzyg0iFsVTXBSEZkB84fX6xM4zETpEuxRpZE7f2DPX2gjDYIgTUhcXJjRlFIrssxFazOUbZNsRNSLApZ70/ZhHLMPNkymITQVkiQZ/aWnXjrBugScd86qg3nPWgUWX066HiynuDtaK4P5HCT3EvXMhoL9zDHj1amOGoRXsxU+oc3ZXi/9vkH1BLAwQUAAAACAAHTE9dP4NNsIAAAACdAAAADwAAAE9FQlBTL25hdi54aHRtbCXMwQ7CIBAE0F8he5e18SIGaOLBox6sH6BCWmJlTdkI/r803CYzL6P78p7F1y8pUDTQyS0IH5/kQhwN3IbTZg+91RNXVWVMBibmzwEx5yzzTtIyYqeUwrIaqNTfndUcePb2SPTS2LLGtjzI/arq7DmUy1UMPrFornYa24zrmf0DUEsBAhQDFAAAAAgAB0xPXW9hqywWAAAAFAAAAAgAAAAAAAAAAAAAAIABAAAAAG1pbWV0eXBlUEsBAhQDFAAAAAgAB0xPXR0yAzafAAAA4gAAABYAAAAAAAAAAAAAAIABPAAAAE1FVEEtSU5GL2NvbnRhaW5lci54bWxQSwECFAMUAAAACAAHTE9d2LtPxh4BAADnAQAAEQAAAAAAAAAAAAAAgAEPAQAAT0VCUFMvY29udGVudC5vcGZQSwECFAMUAAAACAAHTE9dP4NNsIAAAACdAAAADwAAAAAAAAAAAAAAgAFcAgAAT0VCUFMvbmF2LnhodG1sUEsFBgAAAAAEAAQA9gAAAAkDAAAAAA==";
    in
    ''
      import json

      machine.wait_for_unit("bookorbit.service")
      machine.wait_for_open_port(3000)

      with subtest("Homepage is served"):
          machine.succeed("curl --fail --silent ${baseUrl}/ | grep BookOrbit")

      with subtest("Complete first-run setup"):
          setup = json.loads(machine.succeed(
              "curl --fail --silent"
              + " --header 'x-setup-token: abcdefgh'"
              + " --json ${
                jsonArg {
                  username = "${username}";
                  name = "Admin";
                  email = "admin@example.com";
                  password = "${password}";
                }
              }"
              + " ${baseUrl}/api/v1/auth/setup"
          ))
          assert setup["accessToken"], f"Expected an access token, got: {json.dumps(setup)}"

      with subtest("Sign in"):
          login = json.loads(machine.succeed(
              "curl --fail --silent"
              + " --json ${
                jsonArg {
                  username = "${username}";
                  password = "${password}";
                }
              }"
              + " ${baseUrl}/api/v1/auth/login"
          ))
          token = login["accessToken"]
          assert login["user"]["isSuperuser"], f"Expected the first user to be a superuser, got: {json.dumps(login)}"

      with subtest("Identify the signed-in user"):
          me = json.loads(machine.succeed(
              "curl --fail --silent --header 'Authorization: Bearer " + token + "'"
              + " ${baseUrl}/api/v1/auth/me"
          ))
          assert me["username"] == "${username}", f"Expected username '${username}', got: {json.dumps(me)}"

      with subtest("Create a library"):
          library = json.loads(machine.succeed(
              "curl --fail --silent --header 'Authorization: Bearer " + token + "'"
              + " --json ${
                jsonArg {
                  name = "Test Library";
                  icon = "folder";
                  folders = [ "/var/lib/bookorbit/library" ];
                }
              }"
              + " ${baseUrl}/api/v1/libraries"
          ))
          library_id = library["id"]
          assert library_id, f"Expected a library id, got: {json.dumps(library)}"

      with subtest("Upload a book"):
          machine.succeed("echo '${sampleEpub}' | base64 -d > /tmp/test-book.epub")
          upload = json.loads(machine.succeed(
              "curl --fail --silent --header 'Authorization: Bearer " + token + "'"
              + " --form file=@/tmp/test-book.epub"
              + f" ${baseUrl}/api/v1/libraries/{library_id}/upload"
          ))
          book_id = upload["bookId"]
          assert book_id, f"Expected a book id, got: {json.dumps(upload)}"

      with subtest("Uploaded book is retrievable"):
          book = json.loads(machine.succeed(
              "curl --fail --silent --header 'Authorization: Bearer " + token + "'"
              + f" ${baseUrl}/api/v1/books/{book_id}"
          ))
          assert book["id"] == book_id, f"Expected book {book_id}, got: {json.dumps(book)}"
          assert book["libraryId"] == library_id, f"Expected book in library {library_id}, got: {json.dumps(book)}"
    '';
}
