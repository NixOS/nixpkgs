# Test the default interpreter script correctly handle argv0
# when `preserveArgvZero` is enabled.
import ./make-test-python.nix ({ pkgs, ... }: {
  name = "systemd-binfmt-argv0";
  machine = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    boot.binfmt.registrations."aarch64-linux".preserveArgvZero = true;
  };

  testScript = let
    echoArgs = pkgs.pkgsCross.aarch64-multiplatform.runCommandCC "echo-args" {} ''
      cat >echo.c <<EOF
      #include <stdio.h>
      int main(int argc, char **argv) {
        printf("<");
        for (int i = 0; i < argc; ++i)
          printf("%s-", argv[i]);
        puts(">");
        return 0;
      }
      EOF
      mkdir -p $out/bin
      $CC echo.c -o $out/bin/echo -O2
    '';
  in ''
    machine.start()
    ret = machine.succeed(
        "exec -a hello ${echoArgs}/bin/echo world"
    )
    assert "<hello-world->" in ret, "Got: " + ret
  '';
})
