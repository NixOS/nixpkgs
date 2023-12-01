import ./make-test-python.nix ({ lib, pkgs, ...} :
{
  name = "nix-ld";
  nodes.machine = { pkgs, ... }: {
    programs.nix-ld.enable = true;
    environment.systemPackages = [
      (pkgs.runCommand "patched-hello" {} ''
        install -D -m755 ${pkgs.hello}/bin/hello $out/bin/hello
        patchelf $out/bin/hello --set-interpreter $(cat ${pkgs.nix-ld}/nix-support/ldpath)
      '')
    ];
  };
  testScript = ''
    start_all()
    machine.succeed("hello")
 '';
})
