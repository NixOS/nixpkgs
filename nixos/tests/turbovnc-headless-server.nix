import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "turbovnc-headless-server";
  meta = {
    maintainers = with lib.maintainers; [ nh2 ];
  };

  nodes.machine = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      glxinfo
      procps # for `pkill`, `pidof` in the test
      scrot # for screenshotting Xorg
      turbovnc
    ];

    programs.turbovnc.ensureHeadlessSoftwareOpenGL = true;

    networking.firewall = {
      # Reject instead of drop, for failures instead of hangs.
      rejectPackets = true;
      allowedTCPPorts = [
        5900 # VNC :0, for seeing what's going on in the server
      ];
    };

    # So that we can ssh into the VM, see e.g.
    # http://blog.patapon.info/nixos-local-vm/#accessing-the-vm-with-ssh
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "yes";
    users.extraUsers.root.password = "";
    users.mutableUsers = false;
  };

  testScript = ''
    def wait_until_terminated_or_succeeds(
        termination_check_shell_command,
        success_check_shell_command,
        get_detail_message_fn,
        retries=60,
        retry_sleep=0.5,
    ):
        def check_success():
            command_exit_code, _output = machine.execute(success_check_shell_command)
            return command_exit_code == 0

        for _ in range(retries):
            exit_check_exit_code, _output = machine.execute(termination_check_shell_command)
            is_terminated = exit_check_exit_code != 0
            if is_terminated:
                if check_success():
                    return
                else:
                    details = get_detail_message_fn()
                    raise Exception(
                        f"termination check ({termination_check_shell_command}) triggered without command succeeding ({success_check_shell_command}); details: {details}"
                    )
            else:
                if check_success():
                    return
            import time
            time.sleep(retry_sleep)

        if not check_success():
            details = get_detail_message_fn()
            raise Exception(
                f"action timed out ({success_check_shell_command}); details: {details}"
            )


    # Below we use the pattern:
    #     (cmd | tee stdout.log) 3>&1 1>&2 2>&3 | tee stderr.log
    # to capture both stderr and stdout while also teeing them, see:
    # https://unix.stackexchange.com/questions/6430/how-to-redirect-stderr-and-stdout-to-different-files-and-also-display-in-termina/6431#6431


    # Starts headless VNC server, backgrounding it.
    def start_xvnc():
        xvnc_command = " ".join(
            [
                "Xvnc",
                ":0",
                "-iglx",
                "-auth /root/.Xauthority",
                "-geometry 1240x900",
                "-depth 24",
                "-rfbwait 5000",
                "-deferupdate 1",
                "-verbose",
                "-securitytypes none",
                # We don't enforce localhost listening such that we
                # can connect from outside the VM using
                #     env QEMU_NET_OPTS=hostfwd=tcp::5900-:5900 $(nix-build nixos/tests/turbovnc-headless-server.nix -A driver)/bin/nixos-test-driver
                # for testing purposes, and so that we can in the future
                # add another test case that connects the TurboVNC client.
                # "-localhost",
            ]
        )
        machine.execute(
            # Note trailing & for backgrounding.
            f"({xvnc_command} | tee /tmp/Xvnc.stdout) 3>&1 1>&2 2>&3 | tee /tmp/Xvnc.stderr >&2 &",
        )


    # Waits until the server log message that tells us that GLX is ready
    # (requires `-verbose` above), avoiding screenshoting racing below.
    def wait_until_xvnc_glx_ready():
        machine.wait_until_succeeds("test -f /tmp/Xvnc.stderr")
        wait_until_terminated_or_succeeds(
            termination_check_shell_command="pidof Xvnc",
            success_check_shell_command="grep 'GLX: Initialized DRISWRAST' /tmp/Xvnc.stderr",
            get_detail_message_fn=lambda: "Contents of /tmp/Xvnc.stderr:\n"
            + machine.succeed("cat /tmp/Xvnc.stderr"),
        )


    # Checks that we detect glxgears failing when
    # `LIBGL_DRIVERS_PATH=/nonexistent` is set
    # (in which case software rendering should not work).
    def test_glxgears_failing_with_bad_driver_path():
        machine.execute(
            # Note trailing & for backgrounding.
            "(env DISPLAY=:0 LIBGL_DRIVERS_PATH=/nonexistent glxgears -info | tee /tmp/glxgears-should-fail.stdout) 3>&1 1>&2 2>&3 | tee /tmp/glxgears-should-fail.stderr >&2 &"
        )
        machine.wait_until_succeeds("test -f /tmp/glxgears-should-fail.stderr")
        wait_until_terminated_or_succeeds(
            termination_check_shell_command="pidof glxgears",
            success_check_shell_command="grep 'libGL error: failed to load driver: swrast' /tmp/glxgears-should-fail.stderr",
            get_detail_message_fn=lambda: "Contents of /tmp/glxgears-should-fail.stderr:\n"
            + machine.succeed("cat /tmp/glxgears-should-fail.stderr"),
        )
        machine.wait_until_fails("pidof glxgears")


    # Starts glxgears, backgrounding it. Waits until it prints the `GL_RENDERER`.
    # Does not quit glxgears.
    def test_glxgears_prints_renderer():
        machine.execute(
            # Note trailing & for backgrounding.
            "(env DISPLAY=:0 glxgears -info | tee /tmp/glxgears.stdout) 3>&1 1>&2 2>&3 | tee /tmp/glxgears.stderr >&2 &"
        )
        machine.wait_until_succeeds("test -f /tmp/glxgears.stderr")
        wait_until_terminated_or_succeeds(
            termination_check_shell_command="pidof glxgears",
            success_check_shell_command="grep 'GL_RENDERER' /tmp/glxgears.stdout",
            get_detail_message_fn=lambda: "Contents of /tmp/glxgears.stderr:\n"
            + machine.succeed("cat /tmp/glxgears.stderr"),
        )


    with subtest("Start Xvnc"):
        start_xvnc()
        wait_until_xvnc_glx_ready()

    with subtest("Ensure bad driver path makes glxgears fail"):
        test_glxgears_failing_with_bad_driver_path()

    with subtest("Run 3D application (glxgears)"):
        test_glxgears_prints_renderer()

        # Take screenshot; should display the glxgears.
        machine.succeed("scrot --display :0 /tmp/glxgears.png")

    # Copy files down.
    machine.copy_from_vm("/tmp/glxgears.png")
    machine.copy_from_vm("/tmp/glxgears.stdout")
    machine.copy_from_vm("/tmp/glxgears-should-fail.stdout")
    machine.copy_from_vm("/tmp/glxgears-should-fail.stderr")
    machine.copy_from_vm("/tmp/Xvnc.stdout")
    machine.copy_from_vm("/tmp/Xvnc.stderr")
  '';

})
