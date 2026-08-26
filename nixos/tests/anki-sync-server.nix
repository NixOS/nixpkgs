{ pkgs, ... }:
let
  ankiSyncTest = pkgs.writeScript "anki-sync-test.py" ''
    #!${pkgs.python3}/bin/python

    import sys
    import os

    # anki is built with buildPythonApplication.
    # anki.lib is not a 'proper' python library, meaning it
    # is not recognized in 'withPackages' (due to hasPythonModule in
    # https://github.com/NixOS/nixpkgs/blob/7ef35a9f3abb638647d68b10cccae549094b8054/pkgs/development/interpreters/python/python-packages-base.nix#L89
    # and contains the collection of all python libraries used
    # by anki rather than just the anki itself.
    anki_libs = "${pkgs.anki.lib}/${pkgs.python3.sitePackages}"
    if not os.path.isdir(anki_libs):
      print(f"'{anki_libs}' not found, possible python version mismatch")
      exit(1)
    sys.path.append(anki_libs)

    import anki.collection

    col = anki.collection.Collection('test_collection')
    endpoint = 'http://localhost:27701'

    # Sanity check: verify bad login fails
    try:
       col.sync_login('baduser', 'badpass', endpoint)
       print("bad user login worked?!")
       sys.exit(1)
    except anki.errors.SyncError:
        pass

    # test logging in to users
    col.sync_login('user', 'password', endpoint)
    col.sync_login('passfileuser', 'passfilepassword', endpoint)

    # Test actual sync. login apparently doesn't remember the endpoint...
    login = col.sync_login('user', 'password', endpoint)
    login.endpoint = endpoint
    sync = col.sync_collection(login, False)
    assert sync.required == sync.NO_CHANGES
    # TODO: create an archive with server content including a test card
    # and check we got it?
  '';
  testPasswordFile = pkgs.writeText "anki-password" "passfilepassword";
in
{
  name = "anki-sync-server";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ martinetd ];
  };

  nodes.machine = {
    services.anki-sync-server = {
      enable = true;
      users = [
        {
          username = "user";
          password = "password";
        }
        {
          username = "passfileuser";
          passwordFile = testPasswordFile;
        }
      ];
    };
  };

  testScript = ''
    start_all()

    with subtest("Server starts successfully"):
        # service won't start without users
        machine.wait_for_unit("anki-sync-server.service")
        machine.wait_for_open_port(27701)

    with subtest("Can sync"):
        machine.succeed("${ankiSyncTest}")
  '';
}
