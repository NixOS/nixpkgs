{
  self,
  lib,
  testers,
  fetchzip,
  fetchurl,
  writers,
  symlinkJoin,
  jq,
  prom2json,
}:
let
  common-config =
    { config, ... }:
    {
      imports = [ ./module.nix ];
      services.local-ai = {
        enable = true;
        package = self;
        threads = config.virtualisation.cores;
        logLevel = "debug";
      };
    };

  inherit (self.lib) genModels;
in
{
  version = testers.testVersion {
    package = self;
    version = "v" + self.version;
    command = "local-ai --help";
  };

  health = testers.runNixOSTest {
    name = self.name + "-health";
    nodes.machine = common-config;
    testScript =
      let
        port = "8080";
      in
      ''
        machine.wait_for_open_port(${port})
        machine.succeed("curl -f http://localhost:${port}/readyz")

        machine.succeed("${prom2json}/bin/prom2json http://localhost:${port}/metrics > metrics.json")
        machine.copy_from_vm("metrics.json")
      '';
  };

  # https://localai.io/features/embeddings/#bert-embeddings
  bert =
    let
      model = "embedding";
      model-configs.${model} = {
        # Note: q4_0 and q4_1 models can not be loaded
        parameters.model = fetchurl {
          url = "https://huggingface.co/skeskinen/ggml/resolve/main/all-MiniLM-L6-v2/ggml-model-f16.bin";
          hash = "sha256-nBlbJFOk/vYKT2vjqIo5IRNmIU32SYpP5IhcniIxT1A=";
        };
        backend = "bert-embeddings";
        embeddings = true;
      };

      models = genModels model-configs;

      requests.request = {
        inherit model;
        input = "Your text string goes here";
      };
    in
    testers.runNixOSTest {
      name = self.name + "-bert";
      nodes.machine = {
        imports = [ common-config ];
        virtualisation.cores = 2;
        virtualisation.memorySize = 2048;
        services.local-ai.models = models;
      };
      passthru = {
        inherit models requests;
      };
      testScript =
        let
          port = "8080";
        in
        ''
          machine.wait_for_open_port(${port})
          machine.succeed("curl -f http://localhost:${port}/readyz")
          machine.succeed("curl -f http://localhost:${port}/v1/models --output models.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .data[].id == \"${model}\"' models.json")

          machine.succeed("curl -f http://localhost:${port}/embeddings --json @${writers.writeJSON "request.json" requests.request} --output embeddings.json")
          machine.copy_from_vm("embeddings.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .model == \"${model}\"' embeddings.json")

          machine.succeed("${prom2json}/bin/prom2json http://localhost:${port}/metrics > metrics.json")
          machine.copy_from_vm("metrics.json")
        '';
    };

}
// lib.optionalAttrs (!self.features.with_cublas && !self.features.with_clblas) {
  # https://localai.io/docs/getting-started/manual/
  llama =
    let
      model = "gpt-3.5-turbo";

      # https://localai.io/advanced/#full-config-model-file-reference
      model-configs.${model} = rec {
        context_size = 16 * 1024; # 128kb is possible, but needs 16GB RAM
        backend = "llama-cpp";
        parameters = {
          # https://ai.meta.com/blog/meta-llama-3-1/
          model = fetchurl {
            url = "https://huggingface.co/lmstudio-community/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf";
            hash = "sha256-8r4+GiOcEsnz8BqWKxH7KAf4Ay/bY7ClUC6kLd71XkQ=";
          };
          # defaults from:
          # https://deepinfra.com/meta-llama/Meta-Llama-3.1-8B-Instruct
          temperature = 0.7;
          top_p = 0.9;
          top_k = 0;
          # following parameter leads to outputs like: !!!!!!!!!!!!!!!!!!!
          #repeat_penalty = 1;
          presence_penalty = 0;
          frequency_penalty = 0;
          max_tokens = 100;
        };
        stopwords = [ "<|eot_id|>" ];
        template = {
          # Templates implement following specifications
          # https://github.com/meta-llama/llama3/tree/main?tab=readme-ov-file#instruction-tuned-models
          # ... and are insprired by:
          # https://github.com/mudler/LocalAI/blob/master/embedded/models/llama3-instruct.yaml
          #
          # The rules for template evaluateion are defined here:
          # https://pkg.go.dev/text/template
          chat_message = ''
            <|start_header_id|>{{.RoleName}}<|end_header_id|>

            {{.Content}}${builtins.head stopwords}'';

          chat = "{{.Input}}<|start_header_id|>assistant<|end_header_id|>";

          completion = "{{.Input}}";
        };
      };

      models = genModels model-configs;

      requests = {
        # https://localai.io/features/text-generation/#chat-completions
        chat-completions = {
          inherit model;
          messages = [
            {
              role = "user";
              content = "1 + 2 = ?";
            }
          ];
        };
        # https://localai.io/features/text-generation/#edit-completions
        edit-completions = {
          inherit model;
          instruction = "rephrase";
          input = "Black cat jumped out of the window";
          max_tokens = 50;
        };
        # https://localai.io/features/text-generation/#completions
        completions = {
          inherit model;
          prompt = "A long time ago in a galaxy far, far away";
        };
      };
    in
    testers.runNixOSTest {
      name = self.name + "-llama";
      nodes.machine = {
        imports = [ common-config ];
        virtualisation.cores = 4;
        virtualisation.memorySize = 8192;
        services.local-ai.models = models;
        # TODO: Add test case parallel requests
        services.local-ai.parallelRequests = 2;
      };
      passthru = {
        inherit models requests;
      };
      testScript =
        let
          port = "8080";
        in
        ''
          machine.wait_for_open_port(${port})
          machine.succeed("curl -f http://localhost:${port}/readyz")
          machine.succeed("curl -f http://localhost:${port}/v1/models --output models.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .data[].id == \"${model}\"' models.json")

          machine.succeed("curl -f http://localhost:${port}/v1/chat/completions --json @${writers.writeJSON "request-chat-completions.json" requests.chat-completions} --output chat-completions.json")
          machine.copy_from_vm("chat-completions.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .object == \"chat.completion\"' chat-completions.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .choices | first.message.content | split(\" \") | last | tonumber == 3' chat-completions.json")

          machine.succeed("curl -f http://localhost:${port}/v1/edits --json @${writers.writeJSON "request-edit-completions.json" requests.edit-completions} --output edit-completions.json")
          machine.copy_from_vm("edit-completions.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .object == \"edit\"' edit-completions.json")
          machine.succeed("${jq}/bin/jq --exit-status '.usage.completion_tokens | debug == ${toString requests.edit-completions.max_tokens}' edit-completions.json")

          machine.succeed("curl -f http://localhost:${port}/v1/completions --json @${writers.writeJSON "request-completions.json" requests.completions} --output completions.json")
          machine.copy_from_vm("completions.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .object ==\"text_completion\"' completions.json")
          machine.succeed("${jq}/bin/jq --exit-status '.usage.completion_tokens | debug == ${
            toString model-configs.${model}.parameters.max_tokens
          }' completions.json")

          machine.succeed("${prom2json}/bin/prom2json http://localhost:${port}/metrics > metrics.json")
          machine.copy_from_vm("metrics.json")
        '';
    };

}
//
  lib.optionalAttrs
    (self.features.with_tts && !self.features.with_cublas && !self.features.with_clblas)
    {
      # https://localai.io/features/text-to-audio/#piper
      tts =
        let
          model-stt = "whisper-en";
          model-configs.${model-stt} = {
            backend = "whisper";
            parameters.model = fetchurl {
              url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.en-q5_1.bin";
              hash = "sha256-x3xXZvHO8JtrfUfyG1Rsvd1BV4hrO11tT3CekeZsfCs=";
            };
          };

          model-tts = "piper-en";
          model-configs.${model-tts} = {
            backend = "piper";
            parameters.model = "en-us-danny-low.onnx";
          };

          models =
            let
              models = genModels model-configs;
            in
            symlinkJoin {
              inherit (models) name;
              paths = [
                models
                (fetchzip {
                  url = "https://github.com/rhasspy/piper/releases/download/v0.0.2/voice-en-us-danny-low.tar.gz";
                  hash = "sha256-5wf+6H5HeQY0qgdqnAG1vSqtjIFM9lXH53OgouuPm0M=";
                  stripRoot = false;
                })
              ];
            };

          requests.request = {
            model = model-tts;
            input = "Hello, how are you?";
          };
        in
        testers.runNixOSTest {
          name = self.name + "-tts";
          nodes.machine = {
            imports = [ common-config ];
            virtualisation.cores = 2;
            services.local-ai.models = models;
          };
          passthru = {
            inherit models requests;
          };
          testScript =
            let
              port = "8080";
            in
            ''
              machine.wait_for_open_port(${port})
              machine.succeed("curl -f http://localhost:${port}/readyz")
              machine.succeed("curl -f http://localhost:${port}/v1/models --output models.json")
              machine.succeed("${jq}/bin/jq --exit-status 'debug' models.json")

              machine.succeed("curl -f http://localhost:${port}/tts --json @${writers.writeJSON "request.json" requests.request} --output out.wav")
              machine.copy_from_vm("out.wav")

              machine.succeed("curl -f http://localhost:${port}/v1/audio/transcriptions --header 'Content-Type: multipart/form-data' --form file=@out.wav --form model=${model-stt} --output transcription.json")
              machine.copy_from_vm("transcription.json")
              machine.succeed("${jq}/bin/jq --exit-status 'debug | .segments | first.text == \"${requests.request.input}\"' transcription.json")

              machine.succeed("${prom2json}/bin/prom2json http://localhost:${port}/metrics > metrics.json")
              machine.copy_from_vm("metrics.json")
            '';
        };
    }
