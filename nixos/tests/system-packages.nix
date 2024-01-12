{
  name = "system-packages";

  nodes.machine =
    { pkgs, lib, ... }:
    let
      multiOutputDrv = pkgs.runCommand "multi"
        {
          outputs = [ "out" "extra" "foo" ];
        } ''
        mkdir -p "$out/bin"
        cat <<EOF > $out/bin/multi-out
        #!/usr/bin/env sh
        echo "Called multi-out"
        EOF
        chmod a+x $out/bin/multi-out

        mkdir -p "$extra/bin"
        cat <<EOF > $extra/bin/multi-extra
        #!/usr/bin/env sh
        echo "Called multi-extra"
        EOF
        chmod a+x $extra/bin/multi-extra

        mkdir -p "$foo/bin"
        cat <<EOF > $foo/bin/multi-foo
        #!/usr/bin/env sh
        echo "Called multi-foo"
        EOF
        chmod a+x $foo/bin/multi-foo
      '';
    in
    {
      environment.systemPackages = lib.mkMerge [
        [
          pkgs.hello
          multiOutputDrv
          multiOutputDrv.foo
        ]
        [
          pkgs.hello
        ]
        {
          inherit (pkgs) neovim-unwrapped;
          multi = multiOutputDrv.extra;
        }
        {
          multi = multiOutputDrv.extra;
        }
        {
          # Disable a package that was included elsewhere
          "neovim-unwrapped".enable = false;

          # Disable a package from
          "gzip".enable = false;

          # Disable a non-default output of a package that was included elsewhere.
          "multi".outputs.extra.enable = lib.mkForce false;

          # Include a package using the attrset syntax.
          "fd".package = pkgs.fd;
        }
      ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    machine.execute("ls -la /run/current-system/sw/bin/")

    machine.succeed("which hello")
    machine.fail("which nvim")
    machine.succeed("which hello")
    machine.succeed("which multi-out")
    machine.fail("which multi-extra")
    machine.succeed("which multi-foo")
    machine.succeed("which fd")

    machine.succeed("which bzip2")
    machine.fail("which gzip")
    machine.succeed("which xz")
    machine.succeed("which curl")
  '';
}
