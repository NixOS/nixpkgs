import ./make-test.nix ({ pkgs, ... }:
let
  scriptFileData = ''
    #!/run/current-system/sw/bin/gorun
    package main

    import "fmt"

    func main() {
      fmt.Println("Hello World!")
    }
  '';
  scriptFileName = "hello.go";
in {
  name = "gorun";

  meta = {
    maintainers = pkgs.development.tools.gorun.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gorun ];
  };

  testScript = ''
    $machine->succeed("echo '${scriptFileData}' > ${scriptFileName}");
    $machine->succeed("chmod +x ${scriptFileName}");
    $machine->succeed("./${scriptFileName}");
  '';
})
