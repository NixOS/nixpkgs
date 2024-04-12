{ self
, lib
, testers
, fetchzip
, fetchurl
, writers
, symlinkJoin
, linkFarmFromDrvs
, jq
}:
{
  version = testers.testVersion {
    package = self;
    version = "v" + self.version;
  };

  health =
    let
      port = "8080";
    in
    testers.runNixOSTest {
      name = self.name + "-health";
      nodes.machine = {
        systemd.services.local-ai = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig.ExecStart = "${self}/bin/local-ai --debug --localai-config-dir . --address :${port}";
        };
      };
      testScript = ''
        machine.wait_for_open_port(${port})
        machine.succeed("curl -f http://localhost:${port}/readyz")
      '';
    };

  # https://localai.io/docs/getting-started/manual/
  llama =
    let
      port = "8080";
      gguf = fetchurl {
        url = "https://huggingface.co/TheBloke/Luna-AI-Llama2-Uncensored-GGUF/resolve/main/luna-ai-llama2-uncensored.Q4_K_M.gguf";
        sha256 = "6a9dc401c84f0d48996eaa405174999c3a33bf12c2bfd8ea4a1e98f376de1f15";
      };
      models = linkFarmFromDrvs "models" [
        gguf
      ];
    in
    testers.runNixOSTest {
      name = self.name + "-llama";
      nodes.machine =
        let
          cores = 4;
        in
        {
          virtualisation = {
            inherit cores;
            memorySize = 8192;
          };
          systemd.services.local-ai = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig.ExecStart = "${self}/bin/local-ai --debug --threads ${toString cores} --models-path ${models} --localai-config-dir . --address :${port}";
          };
        };
      testScript =
        let
          # https://localai.io/features/text-generation/#chat-completions
          request-chat-completions = {
            model = gguf.name;
            messages = [{ role = "user"; content = "Say this is a test!"; }];
            temperature = 0.7;
          };
          # https://localai.io/features/text-generation/#edit-completions
          request-edit-completions = {
            model = gguf.name;
            instruction = "rephrase";
            input = "Black cat jumped out of the window";
            temperature = 0.7;
          };
          # https://localai.io/features/text-generation/#completions
          request-completions = {
            model = gguf.name;
            prompt = "A long time ago in a galaxy far, far away";
            temperature = 0.7;
          };
        in
        ''
          machine.wait_for_open_port(${port})
          machine.succeed("curl -f http://localhost:${port}/readyz")
          machine.succeed("curl -f http://localhost:${port}/v1/models --output models.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .data[].id == \"${gguf.name}\"' models.json")
          machine.succeed("curl -f http://localhost:${port}/v1/chat/completions --json @${writers.writeJSON "request-chat-completions.json" request-chat-completions} --output chat-completions.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .object == \"chat.completion\"' chat-completions.json")
          machine.succeed("curl -f http://localhost:${port}/v1/edits --json @${writers.writeJSON "request-edit-completions.json" request-edit-completions} --output edit-completions.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .object == \"edit\"' edit-completions.json")
          machine.succeed("curl -f http://localhost:${port}/v1/completions --json @${writers.writeJSON "request-completions.json" request-completions} --output completions.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .object ==\"text_completion\"' completions.json")
        '';
    };

} // lib.optionalAttrs self.features.with_tts {
  # https://localai.io/features/text-to-audio/#piper
  tts =
    let
      port = "8080";
      voice-en-us = fetchzip {
        url = "https://github.com/rhasspy/piper/releases/download/v0.0.2/voice-en-us-danny-low.tar.gz";
        hash = "sha256-5wf+6H5HeQY0qgdqnAG1vSqtjIFM9lXH53OgouuPm0M=";
        stripRoot = false;
      };
      ggml-tiny-en = fetchurl {
        url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.en-q5_1.bin";
        hash = "sha256-x3xXZvHO8JtrfUfyG1Rsvd1BV4hrO11tT3CekeZsfCs=";
      };
      whisper-en = {
        name = "whisper-en";
        backend = "whisper";
        parameters.model = ggml-tiny-en.name;
      };
      models = symlinkJoin {
        name = "models";
        paths = [
          voice-en-us
          (linkFarmFromDrvs "whisper-en" [
            (writers.writeYAML "whisper-en.yaml" whisper-en)
            ggml-tiny-en
          ])
        ];
      };
    in
    testers.runNixOSTest {
      name = self.name + "-tts";
      nodes.machine =
        let
          cores = 2;
        in
        {
          virtualisation = {
            inherit cores;
          };
          systemd.services.local-ai = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig.ExecStart = "${self}/bin/local-ai --debug --threads ${toString cores} --models-path ${models} --localai-config-dir . --address :${port}";
          };
        };
      testScript =
        let
          request = {
            model = "en-us-danny-low.onnx";
            backend = "piper";
            input = "Hello, how are you?";
          };
        in
        ''
          machine.wait_for_open_port(${port})
          machine.succeed("curl -f http://localhost:${port}/readyz")
          machine.succeed("curl -f http://localhost:${port}/tts --json @${writers.writeJSON "request.json" request} --output out.wav")
          machine.succeed("curl -f http://localhost:${port}/v1/audio/transcriptions --header 'Content-Type: multipart/form-data' --form file=@out.wav --form model=${whisper-en.name} --output transcription.json")
          machine.succeed("${jq}/bin/jq --exit-status 'debug | .segments | first.text == \"${request.input}\"' transcription.json")
        '';
    };
}
