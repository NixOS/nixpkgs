import ./make-test-python.nix ({ pkgs, lib, ... }:

let
  # Well, we _can_ cross-compile from Linux :)
  hello = pkgs.runCommand "hello" {
    sdk = "${pkgs.darling.sdk}/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
    nativeBuildInputs = with pkgs.llvmPackages_14; [ clang-unwrapped lld ];
    src = pkgs.writeText "hello.c" ''
      #include <stdio.h>
      int main() {
        printf("Hello, Darling!\n");
        return 0;
      }
    '';
  } ''
    clang \
      -target x86_64-apple-darwin \
      -fuse-ld=lld \
      -nostdinc -nostdlib \
      -mmacosx-version-min=10.15 \
      --sysroot $sdk \
      -isystem $sdk/usr/include \
      -L $sdk/usr/lib -lSystem \
      $src -o $out
  '';
in
{
  name = "darling";

  meta.maintainers = with lib.maintainers; [ zhaofengli ];

  nodes.machine = {
    programs.darling.enable = true;
  };

  testScript = ''
    start_all()

    # Darling holds stdout until the server is shutdown
    machine.succeed("darling ${hello} >hello.out")
    machine.succeed("grep Hello hello.out")
    machine.succeed("darling shutdown")
  '';
})
