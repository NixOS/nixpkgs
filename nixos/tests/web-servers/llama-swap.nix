{ pkgs, lib, ... }:

let
  wrapSrc = attrs: pkgs.runCommand "${attrs.pname}-${attrs.version}" attrs "ln -s $src $out";

  smollm2-135m = wrapSrc rec {
    pname = "smollm2-135m";
    version = "9e6855bc4be717fca1ef21360a1db4b29d5c559a";
    src = pkgs.fetchurl {
      url = "https://huggingface.co/unsloth/SmolLM2-135M-Instruct-GGUF/resolve/${version}/SmolLM2-135M-Instruct-Q4_K_M.gguf";
      hash = "sha256-7V+jDEh7KC7BVsKQYvEiLlwgh1qUSsmCidvSQulH90c=";
    };

    meta.license = with lib.licenses; [
      asl20 # actual license of the model
      unfree # to force an opt-in - do not remove
    ];
  };

  # grab allowUnfreePredicate if it exists or default deny
  allowUnfreePredicate =
    if builtins.hasAttr "allowUnfreePredicate" pkgs.config then
      pkgs.config.allowUnfreePredicate
    else
      (_: false);

  # check if we can use smollm2-135m taking either globally allowUnfree or
  # explicit allow with predicate
  useSmollm2-135m = pkgs.config.allowUnfree || allowUnfreePredicate smollm2-135m;
in
{
  name = "llama-swap";
  meta.maintainers = with lib.maintainers; [
    jk
    podium868909
  ];

  nodes = {
    machine =
      { pkgs, ... }:
      {
        # running models can be memory intensive but
        # default `virtualisation.memorySize` is fine

        services.llama-swap = {
          enable = true;
          settings =
            # config for basic tests
            if !useSmollm2-135m then
              { }
            # config for extended tests using SmolLM2
            else
              let
                llama-cpp = pkgs.llama-cpp;
                llama-server = lib.getExe' llama-cpp "llama-server";
              in
              {
                hooks.on_startup.preload = [
                  "smollm2"
                ];
                # temperature and top-k important for SmolLM2 performance/accuracy
                models = {
                  "smollm2" = {
                    ttl = 10;
                    cmd = "${llama-server} --port \${PORT} -m ${smollm2-135m} --no-webui --temp 0.2 --top-k 9";
                  };
                  "smollm2-group-1" = {
                    cmd = "${llama-server} --port \${PORT} -m ${smollm2-135m} --no-webui --temp 0.2 --top-k 9 -c 1024";
                  };
                  "smollm2-group-2" = {
                    proxy = "http://127.0.0.1:5802";
                    cmd = "${llama-server} --port 5802 -m ${smollm2-135m} --no-webui --temp 0.2 --top-k 9 -c 1024";
                  };
                };
                groups = {
                  "standalone" = {
                    swap = true;
                    exclusive = true;
                    members = [
                      "smollm2"
                    ];
                  };
                  "group" = {
                    swap = false;
                    exclusive = true;
                    members = [
                      "smollm2-group-1"
                      "smollm2-group-2"
                    ];
                  };
                };
              };
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
      # core tests
      import json

      def get_json(route):
        args = [
          '-v',
          '-s',
          '--fail',
          '-H "Content-Type: application/json"'
        ]
        return json.loads(machine.succeed("curl {args} http://localhost:8080{route}".format(args=" ".join(args), route=route)))

      def post_json(route, data):
        args = [
          '-v',
          '-s',
          '--fail',
          '-H "Content-Type: application/json"',
          '-H "Authorization: Bearer no-key"',
          "-d '{d}'".format(d=json.dumps(data))
        ]
        return json.loads(machine.succeed('curl {args} http://localhost:8080{route}'.format(args=" ".join(args), route=route)))

      machine.wait_for_unit('llama-swap')
      machine.wait_for_open_port(8080)

      with subtest('check is serving ui'):
        machine.succeed('curl --fail http:/localhost:8080/ui/')

      with subtest('check is healthy'):
        machine.wait_until_succeeds('curl --silent --fail http://localhost:8080/health | grep "OK"')

    ''
    + lib.optionalString useSmollm2-135m ''
      # extended tests using SmolLM2
      with subtest('check `/running` for preloaded smollm2'):
        machine.wait_until_succeeds('curl --silent --fail http://localhost:8080/running | grep "smollm2"')
        running_response = get_json('/running')
        assert len(running_response['running']) == 1
        running_model = running_response['running'][0]
        assert running_model['model'] == 'smollm2'
        assert running_model['state'] == 'ready'

      with subtest('runs smollm2'):
        response = None
        with subtest('send request to smollm2'):
          data = {
            'model': 'smollm2',
            'messages': [
              {
                'role': 'user',
                'content': 'Say hello'
              }
            ]
          }
          response = post_json('/v1/chat/completions', data)

        with subtest('response is from smollm2'):
          assert response['model'] == 'smollm2'

        with subtest('response contains at least one item in "choices"'):
          assert len(response['choices']) >= 1

        assistant_choices = None
        with subtest('response contains at least one "assistant" message'):
          assistant_choices = [c for c in response['choices'] if c['message']['role'] == 'assistant']
          assert len(assistant_choices) >= 1

        with subtest('first message (lowercase) starts with "hello"'):
          assert assistant_choices[0]['message']['content'].lower()[:5] == 'hello'

        with subtest('check `/running` for just smollm2'):
          running_response = get_json('/running')
          assert len(running_response['running']) == 1
          running_model = running_response['running'][0]
          assert running_model['model'] == 'smollm2'
          assert running_model['state'] == 'ready'

      with subtest('check `/running` for smollm2 to timeout'):
        machine.succeed('curl --silent --fail http://localhost:8080/running | grep "smollm2"')
        machine.wait_until_succeeds('curl --silent --fail http://localhost:8080/running | grep -v "smollm2"', timeout=11)
        running_response = get_json('/running')
        assert len(running_response['running']) == 0

      with subtest('runs smollm2-group-1 and smollm2-group-2'):
        response_1 = None
        with subtest('send request to smollm2-group-1'):
          data = {
            'model': 'smollm2-group-1',
            'messages': [
              {
                'role': 'user',
                'content': 'Say hello'
              }
            ]
          }
          response_1 = post_json('/v1/chat/completions', data)

        with subtest('response 1 is from smollm2-group-1'):
          assert response_1['model'] == 'smollm2-group-1'

        with subtest('response 1 contains at least one item in "choices"'):
          assert len(response['choices']) >= 1

        assistant_choices_1 = None
        with subtest('response 1 contains at least one "assistant" message'):
          assistant_choices_1 = [c for c in response_1['choices'] if c['message']['role'] == 'assistant']
          assert len(assistant_choices_1) >= 1

        with subtest('first message (lowercase) in response 1 starts with "hello"'):
          assert assistant_choices_1[0]['message']['content'].lower()[:5] == 'hello'

        with subtest('check `/running` for just smollm2-group-1'):
          running_response = get_json('/running')
          assert len(running_response['running']) == 1
          running_model = running_response['running'][0]
          assert running_model['model'] == 'smollm2-group-1'
          assert running_model['state'] == 'ready'

        response_2 = None
        with subtest('send request to smollm2-group-2'):
          data = {
            'model': 'smollm2-group-2',
            'messages': [
              {
                'role': 'user',
                'content': 'Say hello'
              }
            ]
          }
          response_2 = post_json('/v1/chat/completions', data)

        with subtest('response 2 is from smollm2-group-2'):
          assert response_2['model'] == 'smollm2-group-2'

        with subtest('response 2 contains at least one item in "choices"'):
          assert len(response['choices']) >= 1

        assistant_choices_2 = None
        with subtest('response 2 contains at least one "assistant" message'):
          assistant_choices_2 = [c for c in response_2['choices'] if c['message']['role'] == 'assistant']
          assert len(assistant_choices_2) >= 1

        with subtest('first message (lowercase) in response 1 starts with "hello"'):
          assert assistant_choices_2[0]['message']['content'].lower()[:5] == 'hello'

        with subtest('check `/running` for both smollm2-group-1 and smollm2-group-2'):
          running_response = get_json('/running')['running']
          assert len(running_response) == 2
          assert len([
            rm for rm in running_response
            if rm['state'] == 'ready' and rm['model'] == 'smollm2-group-1'
          ]) == 1
          assert len([
            rm for rm in running_response
            if rm['state'] == 'ready' and rm['model'] == 'smollm2-group-2'
          ]) == 1
    '';
}
