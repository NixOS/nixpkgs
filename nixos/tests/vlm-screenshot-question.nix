# Reusable VLM screenshot analysis derivation.
#
# Similar to `wait_for_text()` in NixOS VM tests.
#
# Runs a VLM (Vision Language Model) on a screenshot and asserts that the
# model's answer to a yes/no question ends with "YES".
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
        import os
        import re
        import subprocess
        import time

        out = os.environ["out"]
        screenshot = "${screenshot}"
        # Using JSON here even permits preserving multi-line ASCII art questions and so on.
        question = ${builtins.toJSON question}

        # Build the full prompt with output markers for reliable extraction.
        prompt = (
            "Start your output with [output-start]."
            f" {question}"
            " Explain what you see, and your judgment."
            " Then answer that question with exactly YES or NO, followed by [output-end]."
        )

        vlm_start = time.time()
        result = subprocess.run(
            [
                "${lib.getExe llama-cpp}",
                "--single-turn", "--no-display-prompt", "--log-verbosity", "0", "--jinja",
                "--simple-io",  # disables the spinner whose backspace chars would corrupt captured output
                "--reasoning", "off", "--temp", "0",
                "--threads", "1",  # for determinism
                "--n-gpu-layers", "0",  # force CPU-only (results on GPUs might be different and nondeterministic, see https://github.com/ggml-org/llama.cpp/pull/16016#issuecomment-3293505238)
                "--model", "${model}",
                "--mmproj", "${mmproj}",
                "--image", screenshot,
                "-p", prompt,
            ],
            capture_output=True,
            text=True,
            # `OMP_NUM_THREADS=1` prevents OpenMP from spawning extra threads in the BLAS backend
            # (OpenBLAS), which causes nondeterminism with `--image`; without `--image`, `--threads 1`
            # alone is already deterministic (BLAS is not used for short text prompts).
            # Relevant code: https://github.com/ggml-org/llama.cpp/blob/80afa33aadcc4f71212b17e5e52904491c76b63e/ggml/src/ggml-blas/ggml-blas.cpp#L30-L148
            # PR to fix it in OpenBLAS: https://github.com/OpenMathLib/OpenBLAS/pull/5808
            env={**os.environ, "OMP_NUM_THREADS": "1"},
        )
        vlm_elapsed = time.time() - vlm_start
        output = result.stdout
        print(f"VLM inference took {vlm_elapsed:.1f}s")
        print(f"VLM raw output: {repr(output)}")
        if result.returncode != 0:
            print(f"VLM stderr: {result.stderr}")
        assert result.returncode == 0, f"llama-cli failed with exit code {result.returncode}"

        print()

        # Post-process: extract the answer between `[output-start]` and `[output-end]` markers.
        # This is needed because llama-cli prints UI noise (banner,
        # spinner, stats) to stdout alongside the model's response.
        # TODO: Replace with `--quiet` once https://github.com/ggml-org/llama.cpp/pull/22848 is merged;
        #       then also remove the markers from the prompt and the extraction below.
        matches = re.findall(r"\[output-start\](.*?)\[output-end\]", output, re.DOTALL)
        assert matches, (
            f"VLM output did not contain [output-start]...[output-end] markers."
            f" Raw output: {repr(output)}"
        )
        answer = matches[-1].strip()  # use last match (first may be prompt echo)
        print("VLM answer:")
        print(answer)
        assert answer.upper().endswith("YES"), (
            f"VLM did not confirm expected answer. Answer: {answer}"
        )

        os.makedirs(out, exist_ok=True)
        with open(os.path.join(out, "vlm-answer.txt"), "w") as f:
            f.write(answer + "\n")
        os.symlink(screenshot, os.path.join(out, "screen.png"))
      '';
in
runCommand name { } ''
  ${analysisScript}
''
