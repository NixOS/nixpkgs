{ pkgs, lib, ... }:

let
  nipapRc = pkgs.writeText "nipaprc" ''
    [global]
    hostname = [::1]
    port = 1337
    username = nixostest
    password = nIx0st3st
    default_vrf_rt = -
    default_list_vrf_rt = all
  '';
in
{
  name = "lukegb";
  meta.maintainers = [ lib.maintainers.lukegb ];

  nodes.main =
    { ... }:
    {
      services.nipap = {
        enable = true;
      };

      environment.systemPackages = [
        pkgs.nipap-cli
      ];
    };

  testScript = ''
    main.wait_for_unit("nipapd.service")
    main.wait_for_unit("nipap-www.service")

    # Make sure the web UI is up.
    main.wait_for_open_port(21337)
    main.succeed("curl -fvvv -Ls http://localhost:21337/ | grep 'NIPAP'")

    # Check that none of the files we created in /var/lib/nipap are readable.
    out = main.succeed("ls -l /var/lib/nipap")
    bad_perms = False
    for ln in out.split("\n"):
        ln = ln.strip()
        if not ln or ln.startswith('total '):
            continue
        if not ln.startswith('-rw------- '):
            print(f"Bad file permissions: {ln}")
            bad_perms = True
    if bad_perms:
        t.fail("One or more files were overly permissive.")

    # Check we created a web-frontend user.
    main.succeed("nipap-passwd list | grep nipap-www")

    # Create a test user
    main.succeed("nipap-passwd add -u nixostest -p nIx0st3st -n 'NixOS Test User'")

    # Try to log in with it on the web frontend
    main.succeed("curl -fvvv -Ls -b \"\" -d username=nixostest -d password=nIx0st3st http://localhost:21337/auth/login | grep 'PrefixListController'")

    # Try to log in with it using the CLI
    main.copy_from_host("${nipapRc}", "/root/.nipaprc")
    main.succeed("chmod u=rw,go= /root/.nipaprc")
    main.succeed("nipap address add prefix 192.0.2.0/24 type assignment description RFC1166")
    main.succeed("nipap address add prefix 192.0.2.1/32 type host description 'test host'")
    main.succeed("nipap address add prefix 2001:db8::/32 type reservation description RFC3849")
    main.succeed("nipap address add prefix 2001:db8:f00f::/48 type assignment description 'eye pee vee six'")
    main.succeed("nipap address add prefix 2001:db8:f00f:face:dead:beef:cafe:feed/128 type host description 'test host 2'")
  '';
}
