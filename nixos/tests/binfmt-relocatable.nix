# Tests boot.binfmt.relocatable: copies a binary, its loader and libc, and
# a handful of scripts out of the store into a directory the VM then moves
# around, and checks that each one still finds its loader or interpreter
# through $ORIGIN, as a native exec with the expected argv.
{ lib, pkgs, ... }:
let
  # Same default as boot.binfmt.relocatable.ptInterpOriginType.
  ptInterpOriginType = lib.fromHexString "6f726967";

  # Prints its argv and /proc/self/exe, one "key=value" per line.
  showSrc = pkgs.writeText "show.c" ''
    #include <stdio.h>
    #include <unistd.h>

    int main(int argc, char **argv) {
      char exe[4096];
      ssize_t n = readlink("/proc/self/exe", exe, sizeof(exe) - 1);

      if (n < 0) {
        perror("readlink");
        return 1;
      }
      exe[n] = '\0';

      for (int i = 0; i < argc; i++) {
        printf("argv[%d]=%s\n", i, argv[i]);
      }
      printf("exe=%s\n", exe);
      return 0;
    }
  '';

  # Repurposes the first PT_NOTE program header as a PT_INTERP_ORIGIN
  # header pointing at a "$ORIGIN/..." string appended to the file. The
  # kernel and ld.so ignore unknown program header types, and losing the
  # build-id/ABI notes does not matter for this test.
  addInterpOrigin = pkgs.writeText "add-interp-origin.py" ''
    import struct
    import sys

    PT_NOTE = 4
    PF_R = 4
    PHDR = struct.Struct("<IIQQQQQQ")

    path, p_type, value = sys.argv[1], int(sys.argv[2]), sys.argv[3]
    data = bytearray(open(path, "rb").read())

    # Only little-endian ELF64 is handled, like the bpf handler.
    assert data[:4] == b"\x7fELF" and data[4] == 2 and data[5] == 1

    payload = value.encode() + b"\0"
    offset = len(data)
    data += payload

    e_phoff = struct.unpack_from("<Q", data, 0x20)[0]
    e_phentsize, e_phnum = struct.unpack_from("<HH", data, 0x36)
    for i in range(e_phnum):
        base = e_phoff + i * e_phentsize
        if struct.unpack_from("<I", data, base)[0] != PT_NOTE:
            continue
        PHDR.pack_into(data, base, p_type, PF_R, offset, 0, 0, len(payload), 0, 1)
        break
    else:
        sys.exit(f"{path}: no PT_NOTE program header to repurpose")

    open(path, "wb").write(data)
  '';

  # The relocatable tree:
  #   bin/show                plain store binary (the absolute fallback)
  #   bin/origin-interp       PT_INTERP = "$ORIGIN/../lib/<ld.so>"
  #   bin/origin-phdr         PT_INTERP = "/nonexistent/<ld.so>" plus
  #                           PT_INTERP_ORIGIN = "$ORIGIN/../lib/<ld.so>"
  #   bin/line1               "#!$ORIGIN/origin-interp line one"
  #   bin/line2               "#!/nonexistent/sh", then "#!$ORIGIN/..."
  #   bin/line2-leader        "#!/nonexistent/lua", then "-- #!$ORIGIN/..."
  #   bin/line2-compat        "#!<store show>", then "# #!$ORIGIN/..."
  #   lib/                    the loader and libc
  fixtures =
    pkgs.runCommandCC "binfmt-relocatable-fixtures"
      {
        nativeBuildInputs = [
          pkgs.patchelf
          pkgs.python3
        ];
      }
      ''
        mkdir -p $out/bin $out/lib
        ldso=$(cat $NIX_CC/nix-support/dynamic-linker)
        ldname=$(basename "$ldso")

        # The loader and libc move along with the binaries.
        cp "$ldso" "$(dirname "$ldso")/libc.so.6" $out/lib/
        chmod u+w $out/lib/*

        $CC -o show ${showSrc}
        install -m755 show $out/bin/show

        # Loader named in PT_INTERP itself.
        install -m755 show $out/bin/origin-interp
        patchelf --set-interpreter "\$ORIGIN/../lib/$ldname" \
          --set-rpath "\$ORIGIN/../lib" $out/bin/origin-interp

        # Loader named in PT_INTERP_ORIGIN; PT_INTERP cannot work here.
        install -m755 show $out/bin/origin-phdr
        patchelf --set-interpreter "/nonexistent/$ldname" \
          --set-rpath "\$ORIGIN/../lib" $out/bin/origin-phdr
        python3 ${addInterpOrigin} $out/bin/origin-phdr \
          ${toString ptInterpOriginType} "\$ORIGIN/../lib/$ldname"

        printf '#!$ORIGIN/origin-interp line one\n' > $out/bin/line1
        printf '#!/nonexistent/sh\n#!$ORIGIN/origin-interp two\n' > $out/bin/line2
        printf '#!/nonexistent/lua\n-- #!$ORIGIN/origin-interp\n' > $out/bin/line2-leader
        printf '#!%s\n# #!$ORIGIN/origin-interp compat \n' "$out/bin/show" > $out/bin/line2-compat
        chmod 755 $out/bin/line*
      '';
in
{
  name = "binfmt-relocatable";
  meta.maintainers = with lib.maintainers; [ fzakaria ];

  nodes.machine = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.binfmt.relocatable.enable = true;
    system.extraDependencies = [ fixtures ];
  };

  testScript = ''
    def show(cmd):
        """Run cmd and parse the key=value lines printed by show.c."""
        result: dict[str, str] = {}
        for line in machine.succeed(cmd).splitlines():
            key, _, value = line.partition("=")
            result[key] = value
        return result

    machine.wait_for_unit("systemd-binfmt.service")

    with subtest("handlers are registered as bpf entries"):
        for entry, handler in [("elf-origin", "elf_origin"), ("script-origin", "script_origin")]:
            status = machine.succeed(f"cat /proc/sys/fs/binfmt_misc/{entry}")
            assert "enabled" in status, status
            assert f"bpf {handler}" in status, status

    # Copy the tree out of the store and move it, so nothing can be found
    # through a store path or the directory it was first created in.
    machine.succeed(
        "cp -r ${fixtures} /tmp/build",
        "chmod -R u+w /tmp/build",
        "mv /tmp/build /tmp/moved",
    )
    root = "/tmp/moved/bin"

    with subtest("ordinary binaries and scripts are untouched"):
        machine.succeed("true", "${pkgs.runtimeShell} -c true")
        r = show("${fixtures}/bin/show a")
        assert r["exe"] == "${fixtures}/bin/show", r

    with subtest("$ORIGIN in PT_INTERP runs as a native exec"):
        r = show(f"{root}/origin-interp a b")
        assert r["argv[0]"] == f"{root}/origin-interp", r
        assert r["argv[1]"] == "a" and r["argv[2]"] == "b", r
        assert r["exe"] == f"{root}/origin-interp", r

    with subtest("PT_INTERP_ORIGIN wins over an absolute PT_INTERP"):
        r = show("cd /tmp/moved && ./bin/origin-phdr x")
        assert r["argv[0]"] == "./bin/origin-phdr", r
        assert r["exe"] == f"{root}/origin-phdr", r

    with subtest("#!$ORIGIN on line 1, with an argument"):
        r = show(f"{root}/line1 arg")
        assert r["argv[0]"] == f"{root}/origin-interp", r
        assert r["argv[1]"] == "line one", r
        assert r["argv[2]"] == f"{root}/line1", r
        assert r["argv[3]"] == "arg", r

    with subtest("#!$ORIGIN on line 2"):
        r = show(f"{root}/line2")
        assert r["argv[0]"] == f"{root}/origin-interp", r
        assert r["argv[1]"] == "two", r
        assert r["argv[2]"] == f"{root}/line2", r

    with subtest("#!$ORIGIN on line 2 behind a comment token"):
        r = show(f"{root}/line2-leader")
        assert r["argv[0]"] == f"{root}/origin-interp", r
        assert r["argv[1]"] == f"{root}/line2-leader", r

    with subtest("line 2 is preferred, and line 1 takes over without the handler"):
        r = show(f"{root}/line2-compat")
        assert r["argv[0]"] == f"{root}/origin-interp", r
        assert r["argv[1]"] == "compat", r

        machine.succeed("echo 0 > /proc/sys/fs/binfmt_misc/script-origin")
        r = show(f"{root}/line2-compat")
        assert r["exe"] == "${fixtures}/bin/show", r
        assert r["argv[1]"] == f"{root}/line2-compat", r
        machine.succeed("echo 1 > /proc/sys/fs/binfmt_misc/script-origin")

    with subtest("handlers survive a restart of systemd-binfmt"):
        machine.succeed("systemctl restart systemd-binfmt.service")
        r = show(f"{root}/origin-interp")
        assert r["exe"] == f"{root}/origin-interp", r
  '';
}
