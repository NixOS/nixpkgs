import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "vars";
    meta.maintainers = with lib.maintainers; [ lassulus ];

    nodes.machine =
      { ... }:
      {
        vars.settings.on-machine.enable = true;
        vars.generators = {
          simple = {
            files.simple = { };
            script = ''
              echo simple > "$out"/simple
            '';
          };

          a = {
            files.a = { };
            script = ''
              echo a > "$out"/a
            '';
          };
          b = {
            dependencies = [ "a" ];
            files.b = { };
            script = ''
              cat "$in"/a/a > "$out"/b
              echo b >> "$out"/b
            '';
          };

          prompts = {
            files.prompt_line = { };
            files.prompt_hidden = { };
            files.prompt_multiline = { };
            prompts.line = {
              description = ''
                a simple line prompt
              '';
            };
            prompts.hidden = {
              type = "hidden";
              description = ''
                a prompt that doesn't show the input
              '';
            };
            prompts.aamulti = {
              type = "multiline";
              description = ''
                a prompt with multiple lines
              '';
            };
            script = ''
              cp "$prompts"/line "$out"/prompt_line
              cp "$prompts"/hidden "$out"/prompt_hidden
              cp "$prompts"/aamulti "$out"/prompt_multiline
            '';
          };
        };
      };

    testScript =
      { nodes, ... }:
      ''
        import subprocess
        from pathlib import Path

        process = subprocess.Popen(
          ["${nodes.machine.config.system.build.generate-vars}/bin/generate-vars"],
          stdin=subprocess.PIPE,
          stdout=subprocess.PIPE,
          text=True,
          env={
            "OUT_DIR": "./vars",
          },
        )

        # Function to check for expected outputs and send corresponding texts

        def interact_with_process(process, interactions):
            while interactions:
                output = process.stdout.readline()
                if output:
                    print(output.strip())  # Print the output for debugging
                    for expected_output, text_to_send in interactions:
                        if expected_output in output:
                            print("sending", text_to_send)
                            process.stdin.write(text_to_send + '\n')
                            process.stdin.flush()
                            interactions.remove((expected_output, text_to_send))
                            break

        interactions = [
            ("a simple line prompt", "simple prompt content"),
            ("a prompt that doesn't show the input", "hidden prompt content"),
            ("press control-d to finish", f"multi line content1\nmulti line content2\n\n{chr(4)}\n"),
            ("another prompt after EOF", "another prompt content"),
        ]

        # Interact with the process
        interact_with_process(process, interactions)

        # Wait for the process to complete
        process.wait()

        vars_folder = Path("vars")
        print(list(vars_folder.glob("*")))
        assert((vars_folder / "secret" /  "a" / "a").exists())

      '';
  }
)
