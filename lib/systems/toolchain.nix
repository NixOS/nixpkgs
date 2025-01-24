{ lib }:
let
  inherit (lib)
    isAttrs
    ;

  cc = {
    llvm = "clang";
    arocc = "arocc";
    zig = "zig";
    gnu = "gcc";
    default = null;
  };

  bintools = {
    llvm = "llvm";
    gnu = "gnu";
    default = null;
  };

  cxxlib = {
    llvm = "libcxx";
    gnu = "libstdcxx";
    default = null;
  };

  cxxrtlib = {
    llvm = "libcxxabi";
    gnu = {
      linux = "libsupcxx";
      default = "libcxxrt";
    };
    default = null;
  };

  unwindlib = {
    llvm = {
      darwin = "libunwind-system";
      default = "libunwind";
    };
    gnu = "libgcc";
    default = null;
  };

  rtlib = {
    llvm = "compiler-rt";
    gnu = "libgcc";
    default = null;
  };

  components = {
    inherit
      cc
      bintools
      cxxlib
      cxxrtlib
      unwindlib
      rtlib
      ;
  };

  getToolchain =
    platform:
    if platform.useLLVM || platform.useArocc || platform.useZig || platform.isDarwin then
      "llvm"
    else
      # TODO: don't imply GNU when nothing else is specified.
      # Return null once we allow toolchain attributes to be changed.
      "gnu";

  chooseComponent =
    componentName: platform:
    let
      toolchain = getToolchain platform;

      componentSet =
        components."${componentName}"."${toolchain}" or components."${componentName}".default;
    in
    if isAttrs componentSet then
      componentSet."${platform.parsed.kernel.name}" or componentSet.default
    else
      componentSet;
in
components
// {
  inherit chooseComponent;
}
