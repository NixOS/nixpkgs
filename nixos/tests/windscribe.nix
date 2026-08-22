{ lib, ... }:

{
  name = "windscribe";

  meta.maintainers = with lib.maintainers; [ syntheit ];

  nodes.machine =
    { pkgs, config, ... }:
    let
      # Connects to the helper's unix socket. Exits 0 on success, 1 on any
      # error (EACCES for a caller not in the windscribe group, ECONNREFUSED if
      # nothing is listening, ...). Written in Python, not shell: a setgid bash
      # would drop egid back to the real gid (its privileged-mode guard),
      # masking the very group the setgid wrapper grants - the real GUI is a
      # compiled binary and keeps the group.
      helperProbe = pkgs.writeScript "windscribe-helper-probe" ''
        #!${pkgs.python3}/bin/python3
        import socket, sys
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        try:
            s.connect("/var/run/windscribe/helper.sock")
        except OSError as e:
            print("connect failed:", e)
            sys.exit(1)
        print("connected")
      '';
    in
    {
      services.windscribe.enable = true;

      # A desktop user who is NOT in the windscribe group - mirrors how someone
      # actually launches the GUI.
      users.users.alice.isNormalUser = true;

      # At runtime the bundled binaries live only inside the helper service's
      # BindReadOnlyPaths mount namespace (/opt/windscribe is an empty dir in
      # the global namespace). Expose the package tree at a stable path so the
      # test can exercise those binaries directly.
      environment.etc."windscribe-package".source = config.services.windscribe.package;

      # Plain (no setgid) copy of the probe, to confirm the helper socket is
      # genuinely group-gated for a non-member.
      environment.etc."windscribe-helper-probe" = {
        source = helperProbe;
        mode = "0755";
      };

      # setgid-"windscribe" copy of the same probe, built with the very
      # security.wrappers mechanism the module uses for the GUI. Proves a
      # non-member gains egid=windscribe and can reach the socket.
      security.wrappers.windscribe-helper-probe = {
        source = helperProbe;
        owner = "root";
        group = "windscribe";
        setgid = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("windscribe-helper.service")
    machine.wait_for_file("/var/run/windscribe/helper.sock")

    pkg = "/etc/windscribe-package/opt/windscribe"

    # The bundled OpenVPN binary must actually load and run - this exercises
    # the autoPatchelf'd interpreter, rpath, and the bundled libcrypto/libssl
    # in $out/opt/windscribe/lib.
    machine.succeed(f"{pkg}/windscribeopenvpn --version")

    # The Go wstunnel is intentionally unpatched and relies on nix-ld for
    # /lib64/ld-linux-x86-64.so.2. Regression check for the segfault that
    # autoPatchelf would otherwise introduce in the Go runtime.
    machine.succeed(f"{pkg}/windscribewstunnel --version")

    # The CLI wrapper resolves through security.wrappers (setgid'd copy in
    # /run/wrappers/bin). --help exits 0 without requiring an account or display.
    machine.succeed("windscribe-cli --help")

    # --- Helper socket access (regression guard for the GUI startup hang) ---
    # The helper socket is 0770 root:windscribe; the GUI/CLI reach it by running
    # setgid "windscribe" (as the upstream .deb does with `chmod 2755 && chgrp
    # windscribe`). cap_setgid does NOT work here: the app never raises into the
    # group, it only ever drops it, so connect() gets EACCES, surfacing as
    # "Timed out connecting to helper socket" / "app did not start in time".

    # The GUI and CLI wrappers must carry the setgid bit and group "windscribe".
    for prog in ["windscribe", "windscribe-cli"]:
        machine.succeed(f"test -g /run/wrappers/bin/{prog}")
        gid = machine.succeed(f"stat -c %G /run/wrappers/bin/{prog}").strip()
        assert gid == "windscribe", f"{prog} wrapper group is {gid!r}, expected windscribe"

    # A non-member connecting directly is denied - proves the socket is really
    # group-gated (otherwise the check below would pass vacuously).
    machine.fail("su alice -c /etc/windscribe-helper-probe")

    # The same user, launched through a setgid-"windscribe" wrapper, connects.
    machine.succeed("su alice -c /run/wrappers/bin/windscribe-helper-probe")
  '';
}
