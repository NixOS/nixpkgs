{
  callPackage,
}:

# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel cpp17-kernel'

# Jupyter notebook:
# nix shell --impure --expr 'with import <nixpkgs> {}; [ (jupyter.override { definitions = { cpp17 = cpp17-kernel; }; }) ]' -c jupyter-notebook

let
  xeus-cpp = callPackage ./xeus-cpp.nix { };

  mkKernelSpec = std: {
    displayName = builtins.replaceStrings [ "c++" ] [ "C++ " ] std;
    argv = [
      "${xeus-cpp}/bin/xcpp"
      "-std=${std}"
      "-f"
      "{connection_file}"
    ];
    language = "cpp";
    logo32 = "${xeus-cpp}/share/jupyter/kernels/xcpp17/logo-32x32.png";
    logo64 = "${xeus-cpp}/share/jupyter/kernels/xcpp17/logo-64x64.png";
  };

in

{
  cpp11-kernel = mkKernelSpec "c++11";
  cpp14-kernel = mkKernelSpec "c++14";
  cpp17-kernel = mkKernelSpec "c++17";
  cpp20-kernel = mkKernelSpec "c++20";
  cpp23-kernel = mkKernelSpec "c++23";

  inherit xeus-cpp;
}
