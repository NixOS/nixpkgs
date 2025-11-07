{
  lib,
  callPackage,
  cling,
  fetchurl,
  jq,
  makeWrapper,
  python3,
  stdenv,
}:

# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel cpp17-kernel'

# Jupyter notebook:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter.override { definitions = { cpp17 = cpp17-kernel; }; }'

let
  xeus-cling-unwrapped = callPackage ./xeus-cling.nix { };

  xeus-cling = xeus-cling-unwrapped.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ makeWrapper ];

    # xcpp needs a collection of flags to start up properly, so wrap it by default.
    # We'll provide the unwrapped version as a passthru
    flags = cling.flags ++ [
      "-resource-dir"
      "${cling.unwrapped}"
      "-L"
      "${cling.unwrapped}/lib"
      "-l"
      "${cling.unwrapped}/lib/cling.so"
    ];

    fixupPhase = ''
      runHook preFixup

      wrapProgram $out/bin/xcpp --add-flags "$flags"

      runHook postFixup
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      # Smoke check: run a test notebook using Papermill by creating a simple kernelspec
      mkdir -p kernels/cpp17
      export JUPYTER_PATH="$(pwd)"
      cat << EOF > kernels/cpp17/kernel.json
      {
        "argv": ["$out/bin/xcpp", "-std=c++17", "-f", "{connection_file}"],
        "language": "cpp17"
      }
      EOF

      ${python3.pkgs.papermill}/bin/papermill ${./test.ipynb} out.ipynb
      result="$(cat out.ipynb | ${jq}/bin/jq -r '.cells[0].outputs[0].text[0]')"
      if [[ "$result" != "Hello world." ]]; then
        echo "Kernel test gave '$result'. Expected: 'Hello world.'"
        exit 1
      fi

      runHook postInstallCheck
    '';

    passthru = (oldAttrs.passthru or { }) // {
      unwrapped = xeus-cling-unwrapped;
    };
  });

  mkKernelSpec = std: {
    displayName = builtins.replaceStrings [ "c++" ] [ "C++ " ] std;
    argv = [
      "${xeus-cling}/bin/xcpp"
      "-std=${std}"
      "-f"
      "{connection_file}"
    ];
    language = "cpp";
    logo32 = "${xeus-cling-unwrapped}/share/jupyter/kernels/xcpp17/logo-32x32.png";
    logo64 = "${xeus-cling-unwrapped}/share/jupyter/kernels/xcpp17/logo-64x64.png";
  };

in

{
  cpp11-kernel = mkKernelSpec "c++11";
  cpp14-kernel = mkKernelSpec "c++14";
  cpp17-kernel = mkKernelSpec "c++17";
  cpp2a-kernel = mkKernelSpec "c++2a";

  inherit xeus-cling;
}
