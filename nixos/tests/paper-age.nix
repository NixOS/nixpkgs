import ./make-test-python.nix ({ pkgs, ...} :
  let
    payload = "my-payload";
    secret = "my-secret";
    fake-pinentry = pkgs.writeScriptBin "fake-pinentry" ''
#!/bin/sh
# Author: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
#
# License: Creative Commons Zero ("Public Domain Dedication") --
# Anyone may reuse it, modify it, redistribute it for any purpose.
# Copied from https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=blob;f=tests/fake-pinentries/fake-pinentry.sh;h=44aca215a5c14acd7df013cfa08a65827062a31d;hb=16b6b7753229a41fb3b4bf77d34873db8f3cb682

echo "OK This is only for test suites, and should never be used in production"
while read cmd rest; do
    cmd=$(printf "%s" "$cmd" | tr 'A-Z' 'a-z')
    if [ -z "$cmd" ]; then
        continue;
    fi
    case "$cmd" in
        \#*)
        ;;
        getpin)
            echo "D ${secret}"
            echo "OK"
            ;;
        bye)
            echo "OK"
            exit 0
            ;;
        *)
            echo "OK"
            ;;
    esac
done
    '';
  in  {
    name = "paper-age";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ tomfitzhenry ];
    };

    nodes.default = { ... }: {
      environment.systemPackages = [
        pkgs.paper-age
        pkgs.rage
        pkgs.zbar

        fake-pinentry
      ];
    };

    testScript = ''
      start_all()
      default.wait_for_unit("multi-user.target")
      pw = default.succeed("printf ${payload} | PAPERAGE_PASSPHRASE=${secret} paper-age -o - | zbarimg --quiet --raw - | PINENTRY_PROGRAM=fake-pinentry rage -d")
      print(pw)
      assert pw == "${payload}"
  '';
  })
