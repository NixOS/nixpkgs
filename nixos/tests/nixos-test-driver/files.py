from tempfile import TemporaryDirectory

out = Path(os.environ.get("out", "."))

with subtest("File copy methods"):
    for method in [machine.copy_from_host, machine.copy_from_host_via_shell]:
        with subtest(
            f"{method.__name__}/copy_from_vm (file)"
        ), TemporaryDirectory() as tmpdir:
            method(exampleFile, "/tmp/file")
            machine.copy_from_vm("/tmp/file", tmpdir)
            host_files_same(exampleFile, Path(tmpdir, "file"))
            machine.succeed("rm /tmp/file")

    with subtest("copy_from_host/copy_from_vm (dir)"), TemporaryDirectory() as tmpdir:
        machine.copy_from_host(exampleDir, "/tmp/dir")
        machine.copy_from_vm("/tmp/dir", tmpdir)
        host_files_same(exampleFile, Path(tmpdir, "dir", "exampleFile"))
        machine.succeed("rm -r /tmp/dir")

    with subtest("copy_from_vm"):
        machine.succeed("touch /tmp/file")
        machine.copy_from_vm("/tmp/file")
        assert (out / "file").exists()
        (out / "file").unlink()
        machine.succeed("rm /tmp/file")

    with subtest("wait_for_file"):
        machine.succeed("(sleep 5 && echo hello > /tmp/file) &")
        machine.wait_for_file("/tmp/file")
        machine.succeed("rm /tmp/file")

with subtest("wait_for_file"):
    with subtest("success"):
        machine.succeed("(sleep 5 && echo hello > /tmp/file) >&2 &")
        machine.wait_for_file("/tmp/file")
        machine.succeed("rm /tmp/file")

    with subtest("failure"), no_sleep(), must_raise("action timed out"):
        machine.wait_for_file("/will/never/exist", timeout=10)
