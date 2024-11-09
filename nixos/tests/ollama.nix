{ lib, ... }:
let
  mainPort = 11434;
  altPort = 11435;
in
{
  name = "ollama";
  meta.maintainers = with lib.maintainers; [ abysssol ];

  nodes = {
    cpu =
      { ... }:
      {
        services.ollama.enable = true;
      };

    altAddress =
      { ... }:
      {
        services.ollama.enable = true;
        services.ollama.port = altPort;
      };
  };

  testScript = ''
    import json

    def curl_request_ollama(prompt, port):
      json_prompt = json.dumps(prompt)
      return f"""curl http://127.0.0.1:{port}/api/generate -d '{json_prompt}'"""

    prompt = {
      "model": "tinydolphin",
      "prompt": "lorem ipsum",
      "options": {
        "seed": 69,
        "temperature": 0,
      },
    }


    vms = [
      (cpu, ${toString mainPort}),
      (altAddress, ${toString altPort}),
    ]

    start_all()
    for (vm, port) in vms:
      vm.wait_for_unit("multi-user.target")
      vm.wait_for_open_port(port)
      stdout = vm.succeed(curl_request_ollama(prompt, port), timeout = 100)
  '';
}
