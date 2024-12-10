import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    mainPort = "11434";
    altPort = "11435";

    curlRequest =
      port: request: "curl http://127.0.0.1:${port}/api/generate -d '${builtins.toJSON request}'";

    prompt = {
      model = "tinydolphin";
      prompt = "lorem ipsum";
      options = {
        seed = 69;
        temperature = 0;
      };
    };
  in
  {
    name = "ollama";
    meta = with lib.maintainers; {
      maintainers = [ abysssol ];
    };

    nodes = {
      cpu =
        { ... }:
        {
          services.ollama.enable = true;
        };

      rocm =
        { ... }:
        {
          services.ollama.enable = true;
          services.ollama.acceleration = "rocm";
        };

      cuda =
        { ... }:
        {
          services.ollama.enable = true;
          services.ollama.acceleration = "cuda";
        };

      altAddress =
        { ... }:
        {
          services.ollama.enable = true;
          services.ollama.listenAddress = "127.0.0.1:${altPort}";
        };
    };

    testScript = ''
      vms = [ cpu, rocm, cuda, altAddress ];

      start_all()
      for vm in vms:
          vm.wait_for_unit("multi-user.target")

      stdout = cpu.succeed("""${curlRequest mainPort prompt}""", timeout=100)

      stdout = altAddress.succeed("""${curlRequest altPort prompt}""", timeout=100)
    '';
  }
)
