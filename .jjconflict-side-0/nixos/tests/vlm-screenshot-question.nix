# Reusable VLM screenshot analysis derivation.
#
# Similar to `wait_for_text()` in NixOS VM tests.
#
# Runs a VLM (Vision Language Model) on a screenshot and asserts that the
# model's answer to a yes/no question contains a bool response in a JSON field.
#
# This is useful to automatically test software that is otherwise
# hard to test, e.g. "does this 3D program render the bunny correctly?".
# It is especially useful to judge screenshots made in NixOS VM tests.
{
  lib,
  writers,
  fetchurl,
  llama-cpp,
  runCommand,
  # VLM defaults, chosen to pick a model smart enough to be useful
  # for screenshot analysis, but small enough to not consume too much RAM
  # or be too slow for CI.
  model ? (
    fetchurl {
      url = "https://huggingface.co/unsloth/gemma-4-E2B-it-GGUF/resolve/90f9618340396838ee7ff5b0ba2da27da62953d3/gemma-4-E2B-it-Q4_0.gguf";
      hash = "sha256-nEwdSKRi9/iDsomErE9C02bJxXNDTqtoVT4POL9+tQw=";
    }
  ),
  # mmproj = "multimodal projector"
  mmproj ? (
    fetchurl {
      url = "https://huggingface.co/unsloth/gemma-4-E2B-it-GGUF/resolve/90f9618340396838ee7ff5b0ba2da27da62953d3/mmproj-F16.gguf";
      hash = "sha256-FAvo14SXQfiMUHV9UpuENz7o4nBSzCI2hVtTf0qCFfo=";
    }
  ),
  # User-provided arguments:
  name,
  screenshot,
  question,
}:
let
  analysisScript =
    writers.writePython3 "${name}-script" { flakeIgnore = [ "E501" ]; } # allow long lines
      ''
        import json
        import os
        import subprocess
        import sys
        import time

        SYSTEM_PROMPT = (
            'Answer the user question, outputting valid JSON only.'
            ' Schema: { "bool_answer": true | false, "explanation": "..." }'
        )

        out = os.environ["out"]
        # Using JSON here safely escapes arbitrary strings into Python literals
        # (and even permits preserving multi-line ASCII art questions and so on).
        screenshot = ${builtins.toJSON "${screenshot}"}
        question = ${builtins.toJSON question}


        def fail(message):
            sys.exit(message)


        vlm_start = time.time()
        result = subprocess.run(
            [
                "${lib.getExe' llama-cpp "llama-cli"}",
                "--single-turn", "--no-display-prompt", "--log-verbosity", "0", "--jinja",
                "--simple-io",  # disables the spinner whose backspace chars would corrupt captured output
                "--reasoning", "off", "--temp", "0",
                "--threads", "1",  # for determinism

                # Force CPU-only, for both the text model and the multimodal projector
                # (results on GPUs might be different and nondeterministic, see
                # https://github.com/ggml-org/llama.cpp/pull/16016#issuecomment-3293505238).
                "--device", "none",
                "--n-gpu-layers", "0",
                "--no-mmproj-offload",

                "--model", "${model}",
                "--mmproj", "${mmproj}",
                "--image", screenshot,
                "-sys", SYSTEM_PROMPT,
                "-p", question,
            ],
            capture_output=True,
            text=True,
            # Limiting the BLAS backend (OpenBLAS) to one thread prevents nondeterminism with `--image`;
            # without `--image`, `--threads 1` alone is already deterministic (BLAS is not used for short text prompts).
            # Depending on how OpenBLAS is built, it spawns threads via OpenMP (`OMP_NUM_THREADS`)
            # or its own pthreads pool (`OPENBLAS_NUM_THREADS`, legacy `GOTO_NUM_THREADS`),
            # so set all of them.
            # Relevant code: https://github.com/ggml-org/llama.cpp/blob/80afa33aadcc4f71212b17e5e52904491c76b63e/ggml/src/ggml-blas/ggml-blas.cpp#L30-L148
            # PR to fix it in OpenBLAS: https://github.com/OpenMathLib/OpenBLAS/pull/5808
            env={
                **os.environ,
                "OMP_NUM_THREADS": "1",
                "OPENBLAS_NUM_THREADS": "1",
                "GOTO_NUM_THREADS": "1",
            },
        )
        vlm_elapsed = time.time() - vlm_start
        output = result.stdout
        print(f"VLM inference took {vlm_elapsed:.1f}s")
        print(f"VLM raw output: {output!r}")
        if result.returncode != 0:
            print(f"VLM stderr: {result.stderr}")
            fail(f"llama-cli failed with exit code {result.returncode}")

        print()

        # Post-process: extract the first JSON object that has a `bool_answer` key.
        # This is needed because llama-cli prints UI noise (banner, stats) to stdout
        # around the model's response, and the model may output its own decorations
        # such as putting JSON in a Markdown code fence.
        # `raw_decode()` ignores any trailing text after the JSON object.
        # TODO: Simplify with `--quiet` once https://github.com/ggml-org/llama.cpp/pull/22848 is merged.
        decoder = json.JSONDecoder()
        j = None
        index = output.find("{")
        while index != -1:
            try:
                candidate, _ = decoder.raw_decode(output, index)
            except json.JSONDecodeError:
                candidate = None
            if isinstance(candidate, dict) and "bool_answer" in candidate:
                j = candidate
                break
            index = output.find("{", index + 1)

        # On unexpected outputs, include the raw output in the error message on stderr
        # (it's already included on stdout above in all cases).
        if j is None:
            fail(f"VLM output did not contain a valid JSON object with key 'bool_answer'. Raw output: {output!r}")

        bool_answer = j.get("bool_answer")
        explanation = j.get("explanation")
        if not (isinstance(bool_answer, bool) and isinstance(explanation, str)):
            fail(f'VLM output JSON was not of schema {{ "bool_answer": true | false, "explanation": "..." }}. Raw output: {output!r}')

        print(f"Answer: {bool_answer}")
        print(f"Explanation: {explanation}")
        if not bool_answer:
            fail(f"VLM did not confirm expected answer. Answer: {bool_answer}\nExplanation: {explanation}")

        os.makedirs(out, exist_ok=True)
        with open(os.path.join(out, "vlm-answer.json"), "w") as f:
            json.dump(j, f, indent=2)
            f.write("\n")
        # Keep the original file extension, as the screenshot is not necessarily a PNG.
        _, screenshot_ext = os.path.splitext(screenshot)
        os.symlink(screenshot, os.path.join(out, f"screen{screenshot_ext}"))
      '';
in
runCommand name { } ''
  ${analysisScript}
''
